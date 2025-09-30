import streamlit as st
import video_processing as vp
import sys
import os

# Add the current working directory to the system path
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

# Streamlit UI
st.title("AI Fitness Trainer")

# Sidebar selection for exercise mode
st.sidebar.title("Choose Exercise Mode")
exercise_mode = st.sidebar.radio("Select Mode:", ["Upload Video", "Use Webcam"])

# Exercise selection for both modes
exercise_options = {
    "Pushups": "Pushup",
    "Pullups": "Pullup",
    "Bicep Curls": "Bicep Curl",
    "Squats": "Squat",
    "Shoulder Press": "Shoulder Press"
}
exercise_selection = st.sidebar.radio("Choose the exercise:", list(exercise_options.keys()))

st.sidebar.info("Once you upload the video or start the webcam, it will be analyzed, and the repetition counter will display on a separate window.")

# Handle video upload mode
if exercise_mode == "Upload Video":
    uploaded_file = st.file_uploader(f"Upload a video for {exercise_selection}", type=["mp4", "mov", "avi"])
    if uploaded_file is not None:
        st.sidebar.success(f"Processing {exercise_selection} video...")
        # Process video based on exercise selection
        if exercise_selection == "Pushups":
            vp.process_pushup_video(uploaded_file)
        elif exercise_selection == "Pullups":
            vp.process_pullup_video(uploaded_file)
        elif exercise_selection == "Bicep Curls":
            vp.process_bicep_curl_video(uploaded_file)
        elif exercise_selection == "Squats":
            vp.process_squat_video(uploaded_file)
        elif exercise_selection == "Shoulder Press":
            vp.process_shoulder_press_video(uploaded_file)

# Handle webcam mode
elif exercise_mode == "Use Webcam":
    st.sidebar.success(f"Starting webcam for {exercise_selection}...")
    # Process webcam based on exercise selection
    if exercise_selection == "Pushups":
        vp.process_pushup_webcam()
    elif exercise_selection == "Pullups":
        vp.process_pullup_webcam()
    elif exercise_selection == "Bicep Curls":
        vp.process_bicep_curl_webcam()
    elif exercise_selection == "Squats":
        vp.process_squat_webcam()
    elif exercise_selection == "Shoulder Press":
        vp.process_shoulder_press_webcam()
