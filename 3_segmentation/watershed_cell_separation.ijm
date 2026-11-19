// Select the segmentation directory
showMessage("Select the 3_segmentation directory");
baseDir = getDirectory("Select the segmentation directory");

// Open the stack image
File.openSequence(baseDir + "3_label_img/");

// Convert the labeled images to binary masks
setOption("ScaleConversions", false);
run("8-bit");
setThreshold(1, 255, "raw");
setOption("BlackBackground", true);
run("Convert to Mask", "background=Dark black");

// Optional: Save the binary image before watershed
// saveAs("Tiff", baseDir + "label_images.tif");

// Watershed
run("Adjustable Watershed", "tolerance=3 stack");

// Save the processed image with a new filename
saveAs("Tiff", baseDir + "label_images_watershed.tif");

// Close all images after processing
run("Close All");