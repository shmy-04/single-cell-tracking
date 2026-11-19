// Open the processed image stack
showMessage("Select the processed image stack");
inputPath = File.openDialog("Select the processed image stack");
open(inputPath);

// Select the segmentation directory
showMessage("Select the 3_segmentation directory");
baseDir = getDirectory("Select the segmentation directory");

// Define the output directory
saveDir = baseDir + "/1_images/";
File.makeDirectory(saveDir);

// Get the number of slices in the stack
frames = nSlices;

// Process each slice in reverse order
for (i = frames; i > 0; i--) {
	
	// Extract the current slice
	run("Make Substack...", "slices=" + i);

	// Generate a three-digit sequential filename
	a = "" + i;
	if (i < 10) {
		// Add two leading zeros for single-digit indices
		a = "00" + a;
	} else if (i < 100) {
		// Add one leading zero for two-digit indices
		a = "0" + a;
	}
	newname = a + ".tif";
			
	// Save the extracted image
	saveAs("tif", saveDir + newname);

	// Close the extracted image
	close();
}
