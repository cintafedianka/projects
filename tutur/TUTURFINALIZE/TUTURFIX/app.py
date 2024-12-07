from flask import Flask, render_template, Response
import cv2
import mediapipe as mp
import numpy as np
import math
import mysql.connector
from datetime import datetime
import random

app = Flask(__name__)

# Initialize MediaPipe Hands model
mp_hands = mp.solutions.hands
hands = mp_hands.Hands(static_image_mode=False, max_num_hands=2, min_detection_confidence=0.5, min_tracking_confidence=0.5)
mp_drawing = mp.solutions.drawing_utils

# Database configuration
db_config = {
    'user': 'root',
    'password': '',
    'host': 'localhost',
    'database': 'tuturdb'
}

# Map gestures to task IDs
gesture_task_map = {
    "A": 1,
    "B": 2,
    "C": 3,
    "D": 4,
    "E": 5,
    "F": 6
}

# Save image to database
def save_frame_to_db(image, gesture, task_progress_id, task_id):
    try:
        conn = mysql.connector.connect(**db_config)
        cursor = conn.cursor()
        timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        user_id = 4
        is_correct = random.randint(0, 1)
        query = """
        INSERT INTO task_progress 
        (task_progress_id, user_id, task_id, is_correct, timestamp, image, gesture) 
        VALUES (%s, %s, %s, %s, %s, %s, %s)
        """
        cursor.execute(query, (task_progress_id, user_id, task_id, is_correct, timestamp, image, gesture))
        conn.commit()
        cursor.close()
        conn.close()
        print(f"Successfully inserted into database: {task_progress_id}, {user_id}, {task_id}, {is_correct}, {timestamp}, gesture={gesture}")
    except mysql.connector.Error as err:
        print(f"Error: {err}")
        print(f"Failed to insert into database: {task_progress_id}, {user_id}, {task_id}, {is_correct}, {timestamp}, gesture={gesture}")

# Function to recognize gestures based on hand landmarks
def recognize_gesture(hand_landmarks):
    landmarks_y = [hand_landmarks.landmark[i].y for i in range(21)]
    avg_y = sum(landmarks_y) / len(landmarks_y)
    std_dev_y = math.sqrt(sum((y - avg_y) ** 2 for y in landmarks_y) / len(landmarks_y))

    if std_dev_y < 0.03:
        return "Closed"
    else:
        thumb_y = hand_landmarks.landmark[4].y
        index_y = hand_landmarks.landmark[8].y
        middle_y = hand_landmarks.landmark[12].y
        ring_y = hand_landmarks.landmark[16].y
        pinkie_y = hand_landmarks.landmark[20].y

        if thumb_y < index_y and index_y < middle_y and middle_y < ring_y and ring_y < pinkie_y:
            return "A"
        elif thumb_y > index_y and thumb_y > middle_y and thumb_y > ring_y and thumb_y > pinkie_y:
            return "B"
        elif middle_y < thumb_y and ring_y < thumb_y:
            return "C"
        elif index_y < thumb_y and middle_y > thumb_y and ring_y > thumb_y and pinkie_y > thumb_y:
            return "D"
        elif index_y < thumb_y and middle_y < thumb_y and ring_y < thumb_y and pinkie_y < thumb_y:
            return "E"
        elif thumb_y < index_y and thumb_y < middle_y and thumb_y < ring_y and thumb_y < pinkie_y:
            return "F"
        elif index_y < thumb_y and middle_y > thumb_y and ring_y < thumb_y and pinkie_y < thumb_y:
            return "G"
        elif index_y < thumb_y and middle_y > thumb_y and ring_y > thumb_y and pinkie_y < thumb_y:
            return "H"
        elif index_y < thumb_y and middle_y < thumb_y and ring_y > thumb_y and pinkie_y > thumb_y:
            return "I"
        elif thumb_y > index_y and thumb_y < middle_y and thumb_y < ring_y and thumb_y < pinkie_y:
            return "J"
        elif index_y > thumb_y and middle_y < thumb_y and ring_y < thumb_y and pinkie_y > thumb_y:
            return "K"
        elif index_y > thumb_y and middle_y < thumb_y and ring_y < thumb_y and pinkie_y < thumb_y:
            return "L"
        elif index_y > thumb_y and middle_y > thumb_y and ring_y < thumb_y and pinkie_y < thumb_y:
            return "M"
        elif index_y > thumb_y and middle_y > thumb_y and ring_y > thumb_y and pinkie_y < thumb_y:
            return "N"
        elif index_y < thumb_y and middle_y < thumb_y and ring_y < thumb_y and pinkie_y > thumb_y:
            return "O"
        elif thumb_y < index_y and thumb_y > middle_y and thumb_y > ring_y and thumb_y < pinkie_y:
            return "P"
        elif thumb_y < index_y and thumb_y < middle_y and thumb_y > ring_y and thumb_y < pinkie_y:
            return "Q"
        elif thumb_y < index_y and thumb_y < middle_y and thumb_y < ring_y and thumb_y > pinkie_y:
            return "R"
        elif thumb_y > index_y and thumb_y > middle_y and thumb_y < ring_y and thumb_y > pinkie_y:
            return "S"
        elif thumb_y < index_y and thumb_y < middle_y and thumb_y < ring_y and thumb_y < pinkie_y:
            return "T"
        elif index_y > thumb_y and middle_y > thumb_y and ring_y < thumb_y and pinkie_y > thumb_y:
            return "U"
        elif index_y < thumb_y and middle_y > thumb_y and ring_y < thumb_y and pinkie_y > thumb_y:
            return "V"
        elif index_y < thumb_y and middle_y > thumb_y and ring_y > thumb_y and pinkie_y > thumb_y:
            return "W"
        elif index_y > thumb_y and middle_y < thumb_y and ring_y > thumb_y and pinkie_y < thumb_y:
            return "X"
        elif thumb_y > index_y and thumb_y < middle_y and thumb_y < ring_y and thumb_y > pinkie_y:
            return "Y"
        elif thumb_y > index_y and thumb_y > middle_y and thumb_y < ring_y and thumb_y < pinkie_y:
            return "Z"
        else:
            return "Unknown"

# Function to detect hand landmarks from a frame
def detect_hand_landmarks(frame, task_progress_id, task_id):
    rgb_frame = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
    results = hands.process(rgb_frame)

    if results.multi_hand_landmarks:
        detected_gestures = set()  # To track detected gestures in the current frame
        for hand_landmarks in results.multi_hand_landmarks:
            mp_drawing.draw_landmarks(frame, hand_landmarks, mp_hands.HAND_CONNECTIONS)
            gesture = recognize_gesture(hand_landmarks)
            if gesture and gesture not in detected_gestures:
                detected_gestures.add(gesture)
                cv2.putText(frame, gesture, (50, 50), cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 255, 0), 2, cv2.LINE_AA)
                ret, buffer = cv2.imencode('.jpg', frame)
                task_id = gesture_task_map.get(gesture, task_id)
                save_frame_to_db(buffer.tobytes(), gesture, task_progress_id, task_id)
    return frame

# Video generator function
def gen():
    cap = cv2.VideoCapture(0)
    task_progress_id = 1
    task_id = 1
    while cap.isOpened():
        ret, frame = cap.read()
        if not ret:
            break
        frame = cv2.flip(frame, 1)
        frame = detect_hand_landmarks(frame, task_progress_id, task_id)
        ret, buffer = cv2.imencode('.jpg', frame)
        frame = buffer.tobytes()
        yield (b'--frame\r\n'
               b'Content-Type: image/jpeg\r\n\r\n' + frame + b'\r\n')
        task_progress_id += 1

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/video_feed')
def video_feed():
    return Response(gen(),
                    mimetype='multipart/x-mixed-replace; boundary=frame')

if __name__ == "__main__":
    app.run(debug=True)
