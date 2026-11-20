// Ask the user to select the stack image
showMessage("Select the image stack from which analyzed cells will be removed");
stackImagePath = File.openDialog("Select the stack image file");
open(stackImagePath);

// Get the stack image ID and title
stackID = getImageID();
stackTitle = getTitle();

// Make a substack to get the first slice
selectImage(stackID);
run("Make Substack...", "slices=1");

// Get the substack image ID and title
substackID = getImageID();
substackTitle = getTitle();

// Rename the substack image for clarity
newSubstackTitle = "FirstSlice";
rename(newSubstackTitle);

// Ask the user to select the image to subtract
showMessage("Select the replacement image file");
replacementImagePath = File.openDialog("Select the replacement image file");
open(replacementImagePath);

// Get the replacement image ID and title
replacementID = getImageID();
replacementTitle = getTitle();

// Rename the replacement image for clarity
newReplacementTitle = "ReplacementImage";
rename(newReplacementTitle);

// Perform image subtraction using Image Calculator
imageCalculator("Subtract create", newSubstackTitle, newReplacementTitle);

// Get the result of the image subtraction
resultID = getImageID();
resultTitle = getTitle();
print("Result ID: " + resultID);
print("Result Title: " + resultTitle);

// Replace the first slice of the original stack with the result
selectImage(resultID);
run("Select All");
run("Copy");

selectImage(stackID);
setSlice(1);
run("Paste");

// Close the replacement image
selectImage(replacementID);
close();

// Close the substack image
selectImage(substackID);
close();

// Close the result image
selectImage(resultID);
close();

// Show the modified stack
selectImage(stackID);
rename("stack_excluding_analyzed_cells");