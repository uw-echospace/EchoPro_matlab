# README

Matlab EchoPro code. This version corresponds to the code present in the zip file `UW_EchoProMatlab_Repackaged.zip` on Brandon's local machine, as of February 13, 2023. Note that this is the code that was used to create output files for tests within the Python version of EchoPro. The content provided here corresponds to the content of the `EchoPro` folder in that zip file, except that the following files have been removed:

- All input and output data files
- Much of the content in `m_map1.4` (the map plotting toolbox)  that stores the geographical data used in the maps. Only the m scripts in the base level folder are retained
- Excel files under `input_files`
- All subfolders under `other_programs` and all Excel and other data files at the root level. These are not expected to be used directly in EchoPro. We'll add back individual m-script files as needed

## Updated version

The branch [main-brandon-final](https://github.com/uw-echospace/EchoPro_matlab/tree/main-brandon-final) contains a version of the Matlab EchoPro code that includes bug fixes @b-reyes implemented. It is the final version used by Brandon to produce the test output files for the Python version of EchoPro.
