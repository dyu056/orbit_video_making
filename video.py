%matplotlib qt
import matplotlib.pyplot as plt
plt.ion()  # Turn on interactive mode

import numpy as np
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation
from mpl_toolkits.mplot3d import Axes3D
import matplotlib.font_manager as fm
import cv2
from matplotlib.backends.backend_agg import FigureCanvasAgg

# Set up Chinese font
# Method 1: Use a system font (replace with the path to a suitable font on your system)
chinese_font_path = 'msyh.ttc'  # Example: 'C:/Windows/Fonts/SimSun.ttf' on Windows
chinese_font_prop = fm.FontProperties(fname=chinese_font_path)


def calculate_normal_vector(positions):
    # Calculate the average angular momentum vector
    r = positions
    v = np.diff(r, axis=0)
    angular_momentum = np.cross(r[:-1], v)
    normal = np.mean(angular_momentum, axis=0)
    return normal / np.linalg.norm(normal)

def project_to_plane(positions, normal):
    # Project positions onto a plane perpendicular to the normal vector
    projection_matrix = np.eye(3) - np.outer(normal, normal)
    return np.dot(positions, projection_matrix.T)

file_names = ['Asteroid_extended.txt', 'Earth_extended.txt', 'Venus_extended.txt', 'probe.txt', 'collider.txt']
trajectories = []

# Collect all position data
all_positions = []

for file in file_names:
    data = np.loadtxt(file)
    trajectories.append({
        't': data[:, 0],
        'xyz': data[:, 1:4]
    })
    all_positions.extend(data[:, 1:4])

all_positions = np.array(all_positions)

# Calculate the normal vector of the best-fit plane
normal = calculate_normal_vector(all_positions)

# Project all trajectories onto the plane
transformed_trajectories = []
for traj in trajectories:
    projected = project_to_plane(traj['xyz'], normal)
    transformed_trajectories.append({
        't': traj['t'],
        'x': projected[:, 0],
        'y': projected[:, 1]
    })

# Set up the figure and 2D axis
plt.rcParams['font.family'] = chinese_font_prop.get_name()
fig, ax = plt.subplots(figsize=(12, 10))

# Set axis limits
ax.set_xlim(min(traj['x'].min() for traj in transformed_trajectories) - 0.5e8, 
            max(traj['x'].max() for traj in transformed_trajectories) + 0.5e8)
ax.set_ylim(min(traj['y'].min() for traj in transformed_trajectories) - 0.5e8, 
            max(traj['y'].max() for traj in transformed_trajectories) + 0.5e8)

ax.set_xlabel('X （米）')
ax.set_ylabel('Y （米）')
ax.set_aspect('equal')
ax.grid(True)


# Initialize plot objects
colors = ['r', 'g', 'b', 'c', 'm', 'y']
chinese_labels = ['目标小行星', '地球', '金星', "探测器", "撞击器"]  # Add more labels as needed

spacecrafts = []
trajectory_lines = []
valid_trajectories = []

for i, traj in enumerate(transformed_trajectories):
    color = colors[i % len(colors)]
    label = chinese_labels[i] if i < len(chinese_labels) else f'航天器{i+1}'
    
    spacecraft, = ax.plot([], [], f'{color}o', markersize=10, markerfacecolor=color, label=label)
    trajectory, = ax.plot([], [], f'{color}-', linewidth=2)
    
    spacecrafts.append(spacecraft)
    trajectory_lines.append(trajectory)
    valid_trajectories.append(True)

# Add legend
legend = ax.legend(loc='upper left', prop=chinese_font_prop, bbox_to_anchor=(0.02, 0.98))

# Add a text object for displaying the current time
time_text = ax.text(0.02, 0.02, '', transform=ax.transAxes, fontproperties=chinese_font_prop)

# Function to update the plot
def update_plot(current_time):
    for i, (spacecraft, line, traj, is_valid) in enumerate(zip(spacecrafts, trajectory_lines, transformed_trajectories, valid_trajectories)):
        if not is_valid:
            continue
        
        try:
            idx = np.searchsorted(traj['t'], current_time)
            if idx >= len(traj['t']):
                raise IndexError
            
            x, y = traj['x'][idx], traj['y'][idx]
            
            spacecraft.set_data(x, y)
            line.set_data(traj['x'][:idx+1], traj['y'][:idx+1])
            spacecraft.set_visible(True)
            line.set_visible(True)
        except IndexError:
            spacecraft.set_visible(False)
            line.set_visible(False)
            valid_trajectories[i] = False
            print(f"Trajectory {i+1} removed due to index error.")
    
    # Update legend
    for i, (text, line) in enumerate(zip(legend.get_texts(), legend.get_lines())):
        text.set_visible(valid_trajectories[i])
        line.set_visible(valid_trajectories[i])
    
    # Update time display
    time_text.set_text(f'时间: {current_time:.2f}')
    
    fig.canvas.draw()
    fig.canvas.flush_events()


    
# Calculate total time span
start_time = min(traj['t'][0] for traj in transformed_trajectories)
end_time = max(traj['t'][-1] for traj in transformed_trajectories)

# Set the consistent time step
time_step = 100000 # Adjust this value to change the time step

##########################Main loop for interactive plot ##############################
# Main loop

current_time = start_time
while current_time <= end_time:
    update_plot(current_time)
    plt.pause(0.05)  # Adjust this value to control the animation speed
    current_time += time_step

plt.ioff()  # Turn off interactive mode
plt.show()

# Keep the plot open
input("Press Enter to close the plot...")

##########################Main loop for video ##############################
'''
# Set up the video writer
fourcc = cv2.VideoWriter_fourcc(*'mp4v')
video = cv2.VideoWriter('space_trajectories.mp4', fourcc, 30, (1200, 1000))

# Create a canvas for converting matplotlib figures to images
canvas = FigureCanvasAgg(fig)

# Main loop for creating video frames
current_time = start_time
frame_count = 0
while current_time <= end_time:
    update_plot(current_time)
    
    # Convert the matplotlib figure to an image
    canvas.draw()
    image = np.frombuffer(canvas.tostring_rgb(), dtype='uint8').reshape(1000, 1200, 3)
    
    # OpenCV uses BGR color order
    image = cv2.cvtColor(image, cv2.COLOR_RGB2BGR)
    
    # Write the frame to the video
    video.write(image)
    
    current_time += time_step
    frame_count += 1
    if frame_count % 100 == 0:
        print(f"Processed frame {frame_count}")

# Release the video writer
video.release()

print("Video saved as space_trajectories.mp4")
'''