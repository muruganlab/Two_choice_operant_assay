# Bonsai pipeline for 2D behavioral tracking

![Schematic of the pipeline](../../Images/bonsaipipeline.png)

An overview of the behavioral tracking pipeline implemented with Bonsai [Lopes et al.,2015](https://pmc.ncbi.nlm.nih.gov/articles/PMC4389726/). Numbered labels describe the step-by-step implementation of the pipeline. 

**a.** Screenshot of the Bonsai pipeline used to extract the 2D position of the mouse in the operant arena, entry and exit from the social and sucrose reward zones, and the activity of the choice port LEDs using the session video file recorded during the two choice protocol. These parameters are extracted for each frame of the video and concatenated into a .csv file that can be exported for further analysis.

Upon importing the video file, choosing the output filename, and starting the workflow (**numbers 1-3**), Crop functions **4-7** ensure that the tracking zones of the various parameters are as desired. 
The Crop function in **4 & 5** are used to identify the social and sucrose reward zones respectively using a rectangular region of interest. The coordinates of the region can be modified in the properties section of the function which opens the screenshots shown in **(b)** for **4 and 5**. Move the red square to the desired location. 

Similarly the Crop function in **6** is used to identify the extremes of the arena box to track the position of the animal, as shown in **(b)** for **6**. The RoiActivity function in **7** is used the track the choice port LED activity and can be moved to the desired position as shown in **(b)** for **7**. 

These parameters are saved, and the tracking is restarted. 

Monitor the progress of the tracking in the session by double-clicking the FileCapture function (numbered as **1**) that opens the window **8** shown in **(b)**
