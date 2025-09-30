class ExerciseCounter:
    def __init__(self, exercise_name, up_threshold, down_threshold):
        self.exercise_name = exercise_name
        self.up_threshold = up_threshold
        self.down_threshold = down_threshold
        self.is_up = False
        self.rep_count = 0
 
    def update(self, angle):
        if angle < self.down_threshold and not self.is_up:
            self.is_up = True
        elif angle > self.up_threshold and self.is_up:
            self.rep_count += 1
            self.is_up = False
        return self.rep_count

# Adding shoulder press counter
# shoulder_press_counter = ExerciseCounter("Shoulder Press", up_threshold=160, down_threshold=90)