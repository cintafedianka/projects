import pandas as pd
import matplotlib.pyplot as plt
from sklearn.model_selection import train_test_split, cross_val_score
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score, confusion_matrix, ConfusionMatrixDisplay
from sqlalchemy import create_engine, text

def load_data_from_database(host, user, password, database, table):
    # Create a connection string
    connection_str = f"mysql+pymysql://{user}:{password}@{host}/{database}"
    
    # Create a database engine
    engine = create_engine(connection_str)
    
    # Query to fetch data
    query = f"SELECT * FROM {table}"  # Fetch all rows
    
    # Load data into DataFrame
    df = pd.read_sql(query, engine)
    
    # Print the first few rows and data types for debugging
    print("Data types:\n", df.dtypes)
    print("First few rows:\n", df.head())
    
    return df

def preprocess_data(df):
    # Select relevant columns and drop non-feature columns
    x = df.drop(['is_correct', 'user_id', 'image', 'gesture', 'timestamp'], axis=1)  # Exclude columns that might cause issues
    y = df['is_correct']
    
    x_train, x_test, y_train, y_test = train_test_split(x, y, test_size=0.2, random_state=42)
    return x_train, x_test, y_train, y_test, x_test.index

def train_random_forest(x_train, y_train, n_estimators=8, random_state=42):
    clf = RandomForestClassifier(n_estimators=n_estimators, random_state=random_state)
    clf.fit(x_train, y_train)
    return clf

def evaluate_model(clf, x_train, x_test, y_train, y_test):
    mean_cv_scores = cross_val_score(clf, x_train, y_train, cv=5).mean()
    score_training = accuracy_score(y_train, clf.predict(x_train))
    score_testing = accuracy_score(y_test, clf.predict(x_test))
    return mean_cv_scores, score_training, score_testing

def plot_confusion_matrix(y_test, y_pred):
    cm = confusion_matrix(y_test, y_pred)
    cm_display = ConfusionMatrixDisplay(confusion_matrix=cm, display_labels=[False, True])
    cm_display.plot()
    plt.show()

def plot_predictions(results_df):
    plt.figure(figsize=(10, 6))
    plt.plot(results_df['id'], results_df['actual'], label='Actual', marker='o')
    plt.plot(results_df['id'], results_df['predicted'], label='Predicted', marker='x')
    plt.xlabel('ID')
    plt.ylabel('is_correct')
    plt.title('Actual vs Predicted Values')
    plt.legend()
    plt.show()

def save_predictions_to_database(engine, df, table_name):
    # Check if table exists, create if not
    with engine.connect() as connection:
        connection.execute(text(f"""
        CREATE TABLE IF NOT EXISTS {table_name} (
            id INT AUTO_INCREMENT PRIMARY KEY,
            user_id INT,
            actual BOOLEAN,
            predicted BOOLEAN,
            fluency_improvement VARCHAR(3)
        )
        """))
    
    df.to_sql(table_name, engine, if_exists='append', index=False)

def main():
    host = "localhost"
    user = "root"
    password = ""
    database = "tuturdb"
    table = "task_progress"
    prediction_table = "task_progress_predictions"

    # Load data from the database
    df = load_data_from_database(host, user, password, database, table)
    
    # Preprocess the data
    x_train, x_test, y_train, y_test, test_indices = preprocess_data(df)
    
    # Train the Random Forest classifier
    clf = train_random_forest(x_train, y_train)
    
    # Make predictions
    y_pred = clf.predict(x_test)
    
    # Map predictions to fluency improvement
    fluency_improvement = ['Yes' if pred == 1 else 'No' for pred in y_pred]
    
    # Create a DataFrame to display predictions, actual values, and user IDs
    results_df = pd.DataFrame({
        'user_id': df.loc[test_indices, 'user_id'],
        'actual': y_test,
        'predicted': y_pred,
        'fluency_improvement': fluency_improvement
    })
    
    # Add an id column to results_df to use for plotting
    results_df.reset_index(inplace=True)
    results_df.rename(columns={'index': 'id'}, inplace=True)
    
    print("Predictions:")
    print(results_df)
    
    # Save predictions to the database
    engine = create_engine(f"mysql+pymysql://{user}:{password}@{host}/{database}")
    save_predictions_to_database(engine, results_df, prediction_table)
    
    # Retrieve predictions from the database for plotting
    results_df_from_db = load_data_from_database(host, user, password, database, prediction_table)
    
    # Evaluate the model
    mean_cv_scores, score_training, score_testing = evaluate_model(clf, x_train, x_test, y_train, y_test)
    
    print("Mean cross-validation: ", mean_cv_scores)
    print("Scores on training: ", score_training)
    print("Scores on testing: ", score_testing)
    
    # Plot confusion matrix
    plot_confusion_matrix(y_test, y_pred)
    
    # Plot predictions and actual values
    plot_predictions(results_df_from_db)
    
    # Print a message if there are more correct answers than incorrect answers
    num_yes = fluency_improvement.count('Yes')
    num_no = fluency_improvement.count('No')
    
    if num_yes > num_no:
        print("It seems the user is improving!")
    elif num_yes < num_no:
        print("It seems the user needs more practice.")
    else:
        print("The user's performance is balanced.")

if __name__ == "__main__":
    main()
