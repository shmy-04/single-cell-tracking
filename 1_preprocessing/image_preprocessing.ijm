// Open the stack image to be processed before running this macro

// Select the output directory.
showMessage("Select Save Folder");
saveDir = getDirectory("Choose a Directory"); 

// Perform background subtraction and contrast enhancement
rename("stack");
run("8-bit");
run("Duplicate...", "duplicate");
run("Gaussian Blur...", "sigma=10 stack");
imageCalculator("Subtract create 32-bit stack", "stack","stack-1");
selectImage("stack");
close();
selectImage("stack-1");
close();
selectImage("Result of stack");
run("8-bit");
run("Enhance Contrast...", "saturated=0.35 normalize process_all");

// Save the processed image with a new filename
newname = "processed stack" + ".tif";
saveAs("tif", saveDir + newname);

// Close all images after processing
run("Close All");
