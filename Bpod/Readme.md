# Bpod Graphical User interface and associated protocols

The two choice operant assay and its associated training protocols are designed on the open-source MATLAB software platform for the Bpod system hardware. The current folder includes the [Bpod_Gen2 repository](https://github.com/sanworks/Bpod_Gen2) necessary for coding the state machine logic, along with the folders required for the protocols. We have developed a modified version of the graphical user interface to choose, and navigate between the 4 protocols of the two choice asssay. The general flow of the graphical user interface for initiating and running the two choice assay protocols is shown below. 

![Schematic of the assay](../Images/GUIScreenshots.png)

a) GUI elements of the Bpod console with numbered insets for testing and setting up the operant assay. If a successful connection is established between the Bpod hardware and the computer, running the Bpod command in MATLAB will open the console GUI as shown in the left panel of (a). The numbers refer to (1) the wrench icon to access the settings menu GUI shown on the right panel of (a); (2) port icon to enable behavioral ports 1-3; (3) the LED buttons of the behavioral ports that can be toggled from the OFF (red colored button) to the ON (green colored button) state; (4) the valve button for behavioral port 2 that opens the solenoid valve to allow the flow of liquid to the port from the reward reservoir in the ON state; (5) liquid calibration icon for precise delivery of the reward; (6) BNC1 button to open and close the social gate in the ON state and OFF state respectively; (7) start/pause button that opens the protocol launch manager. b) The launch manager features two panels with drop-down lists to choose from one of the four protocols (blue dialog box, defaults to the Operant conditioning protocol), and select the mouse’s id (pink dialog box, defaults to a dummy subject). The plus icon (highlighted in orange) next to the drop-down menu is used to add a new mouse id to the protocols (orange dialog box). The next button in the bottom right of the launch manager navigates to the protocol parameters window that is unique to the chosen protocol. c) The template for protocol parameters. Users can verify and modify the parameters associated with the protocol such as session duration, duration of the inter-trial interval, amount of sucrose reward dispensed, etc. The back button in the bottom left can be used to revert to the launch manager and the next button can be used to advance to the session summary window which is unique to each protocol. d) A template of the session summary window. This window features the chosen protocol settings, in-progress results featuring trial numbers, and a stairstep graph that serves as a visual representation of the trial progression in the session. At the end of the session, the session summary window is automatically saved within the data folder corresponding to the mouse id.


Note : The Bpod_Gen2 repository files are untracked to ensure compatibility with the downstream GUI functions and the protocol files. The Two_choice_operant_assay will be regularly updated for significant changes in the code base. 