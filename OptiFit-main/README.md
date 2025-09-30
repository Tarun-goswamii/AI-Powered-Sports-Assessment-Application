# OptiFit
The ** OptiFit** is a Python-based project that uses MediaPipe, OpenCV, and Streamlit to analyze exercise videos or live webcam feeds, detecting body posture and counting repetitions for specific exercises. The trainer supports **Pushups**, **Pullups**, **Bicep Curls**, **Squats**, and **Shoulder Press**.

---

## 🚀 Features

1. **Exercise Recognition**: Detects and counts repetitions for:
   - Pushups
   - Pullups
   - Bicep Curls
   - Squats
   - Shoulder Press
2. **Modes of Input**:
   - Upload a video file.
   - Use live webcam feed.
3. **Real-Time Feedback**: Displays pose landmarks and live repetition counters.
4. **Interactive UI**: Built using Streamlit for easy user interaction.

---

## 🛠️ Tech Stack

- **Programming Language**: Python
- **Libraries**:
  - OpenCV: Video processing
  - MediaPipe: Pose detection
  - Streamlit: Web app interface
  - NumPy: Mathematical computations
  - Tempfile: Temporary file handling

---

---

## 🔧 Setup Instructions

### Prerequisites

- Python 3.8+
- Virtual environment (optional but recommended)

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/AI_Fitness_Trainer.git
   cd AI_Fitness_Trainer
   
2. Create and activate a virtual environment
   ```bash
   python -m venv env
   source env/bin/activate  # On Windows: .\env\Scripts\activate

3.Install Dependencies
  ```bash
  pip install -r requirements.txt
  ```


4.Run the application:
  ```bash
  streamlit run app.py
  ```
## 📖 How It Works

### Video Mode
1. Upload a video of one of the supported exercises.
2. The app detects body landmarks and calculates joint angles to count repetitions.
3. Results are displayed in a separate OpenCV window.

### Webcam Mode
1. Select the webcam mode from the sidebar.
2. Perform exercises in front of your webcam for real-time analysis.
3. Repetition count updates dynamically on the live video feed.

---

## 📜 File Structure

```plaintext
📁 AI_Fitness_Trainer
├── app.py                # Main Streamlit app
├── exercise_counter.py   # Handles repetition counting logic
├── pose_detection.py     # Pose detection and angle calculation
├── video_processing.py   # Processes video or webcam input
├── requirements.txt      # Project dependencies
└── README.md             # Project documentation
```
## 🎯 Supported Exercises

1. **Pushups**  
   - Detects arm movement using shoulder, elbow, and wrist landmarks.

2. **Pullups**  
   - Identifies shoulder and arm motion to count pullup repetitions.

3. **Bicep Curls**  
   - Tracks elbow flexion and extension for accurate repetition counting.

4. **Squats**  
   - Analyzes hip, knee, and ankle angles to count squats.

5. **Shoulder Press**  
   - Uses shoulder and arm motion to detect press repetitions.

## 🙏 Acknowledgments

We would like to thank the following resources and tools that made this project possible:

- **[MediaPipe](https://google.github.io/mediapipe/)**: For providing robust pose detection solutions.
- **[OpenCV](https://opencv.org/)**: For powerful video and image processing capabilities.
- **[Streamlit](https://streamlit.io/)**: For creating an intuitive and interactive web app interface.
- **[NumPy](https://numpy.org/)**: For efficient mathematical and array computations.
- The Open Source Community for providing countless tutorials and forums that guided this project.
- All contributors and testers for their valuable feedback.

---
