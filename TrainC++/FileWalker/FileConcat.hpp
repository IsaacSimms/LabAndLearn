// == FileConcat.hpp                   == //
// == interface for file contatenation == //

// == shape / sudo code == //
/* 
Initial: shape is going to look like a .exe execution that takes three file paths, two input paths that already exist and an output path.
Success: the destination path contine file 1 and file 2 bytes concatenated together with nothing else.
Failure: The dest path is not created, the bytes where not concatenated correctly, dest path created in the wrong location, etc.
Caller:  true / false bool on predefined success behavior. Maybe an eventual try / catch block
*/

