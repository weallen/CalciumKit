*CalciumKit*
Written by Will Allen (we.allen@gmail.com)

> Preliminaries
- To register files, use the StackReg plugin for ImageJ. The simplest way to use this plugin on a 4D movie is the movie from a sequence of Z stacks (one for each time point) to a sequence of T stacks (one for each Z section), and then align each Z section independently, before converting back to a sequence of Z stacks.
- Registration can improve automatic ROI computation and plotting.
- If you have the Miji plugin for MATLAB installed (this comes with Fiji), you can use the function "stackregister" to register a directory of images. For an example of how to use stackregister, look in "labmeetingAug27.m"

> Using CalciumKit
>> Starting the Program
To run the GUI interface for CalciumKit, set the current directory of MATLAB to the CalciumKit folder, and type "stackroigui" in the MATLAB command prompt. 

If errors occur while using the GUI, the easiest fix is to simply close the GUI window and restart it by typing "stackroigui" again.

Most of the functionality of the software can also be controlled programmatically, using the functions "stackpca", "stackica", "stackfilter", "stackdfof", and "stackicafindcells". For examples of how to use these functions, look in "dostack.m" and "labmeetingAug27.m".
>> Hotkeys
- "l" moves the image +1 frame, "h" moves -1 frame, "j" moves down 1 Z section, and "k" moves up 1 Z section. "q" quits the program.

>> Loading Images
- Press the "Load Images" button to load a sequence of images from some directory. In the popup window, simply click on the directory containing the image sequence you want to import. 
- The program expects that the images are arranged in the way they are exported from SlideBook: each time point is its own image file. If it is a 4D capture, each of these images encloses a Z stack as a multipage TIFF (and all the images have the same size Z stack). If it is a 3D capture, each image is a single page TIFF. 
- NOTE: The program is sensitive to the naming of these files, and may load them out of order if they are not correctly named. For example, it would load "Image10.tiff" before "Image2.tiff". To make sure it imports the images in the correct order; for example, for a series of 100 images label the files "001.tiff", "001.tiff",...,"100.tiff".

- Optionally, one can denoise the imported images by selecting the option button "Denoise?" and specifying a filter size in pixels below. Typically, a value of 1-2 pixels works well; above that and the image becomes blurry. Denoising the image applies a median filter to each image in the stack with a filter size given by the number in the "Denoise Size" box.  

>> Saving Images 
Specify a directory to save Plot and DF/F image output and input a prefix that is used for all output.

>> Viewing Images
- The "<" and ">" buttons move the -1 or +1 frame in time.
- The "Up" and "Down" buttons move the view up and down in the stack while in stack mode. If in Z-projection mode, these movements are disabled.
- In stack mode, the "Use Z" range specifies the active range of Z slices in the stack to view and to analyze. This setting also restricts the automatic ROI analysis and maximum DF/F image creation to that Z range. This specifies what I refer to as the "active Z range".
- The "Show" button panel allows one to either view and analyze the images as a 3D video of Z-stacks or as 2D video of Z-projected images. Upon switching from stack to Z-projection mode, the current Z range (specified by "Use Z") is used to created the sequence of Z-projected images.  NOTE: all ROIs are deleted upon switching from stack mode to Z-projection mode and vice-versa. 
- In both stack and Z-projection mode, the "Use T" range specifies the active range of time points. This range restricts which time points are plotted in the Data Viewer window, which frames are analyzed for automatic ROI generation, and which frames are used in the maximum DF/F image creation. This specifies what I refer to as the "active T range".

>> Analysis: Automatic ROI Creation
There are two methods for automatically creating ROIs in CalciumKit. 
* Filtering
This uses a method described in a paper from Florian Engert's lab. The "Window Size" option specifies a square window size with which to filter the image, and so should be an integer that is about half the size of a single cell. Typically, values of 5-7 work well.

* PCA/ICA
This approaches uses a combination of PCA dimensionality reduction and spatio-temporal ICA, originally developed by Mark Schnitzer's lab in the "CellSort" toolbox, to find cells and neuropil as sets of pixels that are highly correlated in space and time. 
** Num PC specifies the number of principal components to reduce the video to for further analysis. This should typically be set to a few less than the number of frames in the current T range. (E.g. for a video with 20 frames set to 15-19).
** Num IC specifies the number of independent components to separate the video into. Each independent component represents a set of pixels that change value in a way that is both spatially and temporally correlated. As such, this should be set to the number of times there are distinct patterns of cellular activation in the video, plus one for the background. 
For example, in a video with one stimulation that shows first one set of cells light up, then another set, then nothing, I use 3 ICs (1 for the first set, 1 for the second set, 1 for the background bleach change in fluorescence). 
For experiments with a single trp stimulation, I typically use 3 ICs. 
** Use PC specifies the number of principal components to use in the ICA analysis. This necessarily can be at most the number of PCs specified in the first box. Using fewer PCs may result in removing uncorrelated noise from the video, and so allowing for better cell segmentation. (The PCs are sorted by their contribution to the overall signal, and the higher numbered PCs tend to represent mostly noise.) I typically use a value that is about half the "Num PC". 

Example usage: video with 20 frames, 1 trp activation showing 2 distinct sets of cells lighting up. Num PC = 18, Num IC = 3, Use PC = 10.

- If "Make ROIs" is checked, the output of the PCA/ICA or filtering is used to automatically create ROIs that are added to the ROI manager. If not, figures pop up with a colored representation of the filtered images or independent components overlaid on a mean image. 
- The "ROI Threshold" value determines how many ROI to keep from the set of automatically identified ROI. Typically values between 0.5 - 2.5 work well. A lower threshold will result in more ROIs being created, and a higher threshold will result in fewer; the ROIs that pass a higher threshold correspond to regions that are more likely to contain cells or neuropil.

>> DF/F Image Creation
- This panel allows one to make DF/F or DF images from the current movie, using a specified Z and T range. 
- The "F Options" panel allows one to compute the "F0" baseline fluorescence image in two different ways:
	- First, the "Rolling" option allows one to compute a per-frame rolling average over the previous N frames, where N is specified by the "Win Size" edit box. Typically values of 2-5 work well for this. Note that "Win Size" must be less than the current minimum T value specified in "Use T" (e.g. it is not allowed for you to average over the previous 3 frames when your active T range starts at frame 2).
	- Second, the "T Range" option allows one to specify a sequence of frames anywhere in the movie to average over to create the F0 baseline fluorescence. "Min T" and "Max T" can be anywhere in the movie, even outside of the active T range. For example, if you know your activation occurs at frame 10, you set the F0 T Range to be frames 1-9, so that the DF you see is maximal compared to the prestimulus values.
- The "Z-project?" checkbox allows you to show the maximum Z-projection of DF/F or DF values over the active Z range in stack mode. If "Show ROI?" is checked, this option also shows all of the ROIs from all active Z slices, and renumbers the ROIs so that they are labeled consistently.
- The "Show ROI?" toggles whether ROIs are shown in the DF/F or DF image produced.
- The "Just DF?" checkbox toggles whether the DF/F = (F-F0)/F0 or the DF = F-F0 image is shown. 
- If "Save Output?" option is checked, the image that pops up is also saved to the directory specified in Save panel, with the prefix specified there.
- If "Overlay on Background?" is checked, the DF/F or DF image is overlaid on the mean fluorescence image over the active T range (as set by "Use T"). The "Background Thresh" slider allows one to set a minimum cutoff, below which the mean image is shown rather than the DF/F. 
- The "Foreground Thresh" slidebar sets an upper threshold for the DF/F image being created. Anything above the threshold is clamped to the threshold. This bar's range depends on the maximum and minimum values of the DF/F image being thresholded.
 NOTE: both the "Foreground" and "Background" sliders depend on properties of the video being analyzed, and so to produce the best image it is often best to try several settings to find the best looking combination.
- The 'Denoise' slidebar, which ranges in value from 0 - 10, filters the DF/F image with a window of the size of the slider bar's current value (if greater than 0).

>> Plot Creation
* Intensity: plot the raw pixel values from each of the ROIs.
* DF/F: plot the DF/F values from each ROI, where DF/F = F/F0 - 1. (F0 is the baseline fluorescence.)
* DF: plot the DF values from each ROI, where DF = F - F0. 
* Normalized: plot the Z-score of the intensity values for each ROI, at each time point. 
- "Save Plot" saves the current plot in the Data Viewer to the directory specified in the Save panel. 
- In stack mode, the option "All Z slices?" shows the plots for the ROIs in all of the Z-slices in the stack. These are renumbered in the "Show Stacked Plot" if "Show Numbers?" is checked.
- The "Use DF/F Options?" checkbox uses the settings from the Image DF/F:F Options panel for the plot settings (computing F0 either as a rolling average or just in the T range specified in F Options). If this box is unchecked, F0 is computed as the average over all of the currently active frames. 
- "Show Stacked Plot" pops up a plot of the traces currently displayed in the Data Viewer, but stacked rather than overlaid. If "Show Numbers?" is checked, a number corresponding to each ROI will be shown next to its trace.

>> ROI Manager
- "Show Numbers?" shows the number of each ROI overlaid in white. 
- "Add ROI" allows one to draw an ROI on the image freehand. To draw an ROI, simply sketch the outline of the ROI and then double click to add it to the ROI manager.
- "Add Ellipse ROI" is the same as "Add ROI" but it creates an elliptical ROI instead of a freehand ROI.
- "Clear ROI" clears the ROIs from the current Z slice.
- "Clear All ROIs" clears all the ROIs from all Z slices.
- "Undo Last ROI" removes the highest numbered (most recent) ROI.
- "Toggle All ROIs" toggles the visibility of all ROIs in a Z slice (listed below the button).
- The table of ROIs lists each ROI's number in the color it is displayed in. The checkbox next to each number allows one to toggle that ROI's visibility. This toggle affects to ROI's visibility both in the image, and it's associated time trace plot in the Data Viewer. 
- Upon toggling an ROI's visibility, you must press "Redraw ROIs" to update the display.
- The "ROI Color" panel allows one to select how the ROIs are colored. The "Random" option colors the ROIs randomly. The "Depth" option colors ROIs by their position in the Z stack (each ROI in a given Z slice is the same color, but each Z slice is colored differently from red -> blue in HSV color space). The "Fixed" option allows one to select a color from a palette, and use that color for all ROIs across all Z slices. If no color is chosen, the default color is red. These options affect the color of the traces shown in the plot in the Data Viewer as well. 
