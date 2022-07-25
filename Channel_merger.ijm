/*
 * Macro template to process multiple images in a folder
 */

#@ File (label = "Input directory", style = "directory") input
#@ String (label = "File suffix", value = ".tif") suffix

// See also Process_Folder.py for a version of this code
// in the Python scripting language.

processFolder(input);

// function to scan folders/subfolders/files to find files with correct suffix
function processFolder(input) {
	list = getFileList(input);
	list = Array.sort(list);
	for (i = 0; i < list.length; i++) {
		if(File.isDirectory(input + File.separator + list[i]))
			processFolder(input + File.separator + list[i]);
		if(endsWith(list[i], suffix))
			processFile(input, list[i]);
	}
}


function processFile(input, file) {
run("Bio-Formats Importer", "open=[" + input + File.separator + file + "] autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");


Stack.getDimensions(width, height, channels, slices, frames); //Returns the dimensions of the current image.

Dialog.create("Choose Channel Colors");
Dialog.addMessage("Choose the color for each channel.");
options1 = newArray("Red","Green","Blue","Cyan","Magenta","Yellow");
for (i=0; i<channels; i++){
	Dialog.addChoice("Channel "+ i+1 + ":", options);
	}
Dialog.show();

//per channel
for(i=0; i<channels; i++){
	Stack.setChannel(i)
	run(Dialog.getChoice());
	run("Enhance Contrast", "auto");

run("Enhance Contrast", "auto");
}
run("Make Composite");

run("RGB Color");

saveAs("Tiff", input + File.separator + "merged_channels" + file);
run("Close All")
}
