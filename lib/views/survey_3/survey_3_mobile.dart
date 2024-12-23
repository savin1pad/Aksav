// ignore_for_file: unused_field

part of survey_3_view;

class _Survey3Mobile extends StatefulWidget {
  const _Survey3Mobile();

  @override
  State<_Survey3Mobile> createState() => _Survey3MobileState();
}

class _Survey3MobileState extends State<_Survey3Mobile> with LogMixin {
  File? _selectedImage; // Temporary storage for the selected image (File)
  String? _uploadedImageUrl; // Store the uploaded image URL

  // Access StorageRepository using GetIt
  final StorageRepository _storageRepository = app<StorageRepository>();

  // Function to pick an image from the gallery
  Future<XFile?> _pickImageFromGallery() async {
    try {
      final XFile? pickedFile = await _storageRepository.handleGallerOpening();
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
        // Upload the image and get the URL
      }
      return pickedFile;
    } catch (e) {
      // Handle errors (e.g., user cancels image selection)
      warningLog('Error picking image: $e');
    }
    return null;
  }

  // Function to pick an image from the camera
  Future<XFile?> _pickImageFromCamera() async {
    try {
      final XFile? pickedFile = await _storageRepository.handlecameraOpening();
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
        // Upload the image and get the URL
      }
      return pickedFile;
    } catch (e) {
      // Handle errors (e.g., user cancels image selection)
      warningLog('Error picking image: $e');
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final user = RepositoryProvider.of<UserModel>(context);
    final goal = RepositoryProvider.of<GoalModel>(context);
    return Center(
      child: Container(
        height: 350,
        width: 350,
        decoration: const BoxDecoration(
          color: Color(0xffF3F4FE),
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Text(
                'Question 3 of 3',
                style: TextStyle(
                    color: Color(0xffA7A0A0),
                    fontSize: 13,
                    fontFamily: 'UnileverShilling',
                    fontWeight: FontWeight.w400),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0, top: 20.0),
              child: Row(
                children: [
                  Lottie.asset(
                    'assets/achieve.json',
                    height: 50,
                    width: 50,
                  ),
                  const Expanded(
                    child: Text(
                      'Upload Your Image', // Updated text
                      style: TextStyle(
                        fontFamily: 'UnileverShilling',
                        color: Colors.black,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Center(
              // Center the image upload area
              child: SizedBox(
                height: 200, // Set a fixed height for the image area
                child: _selectedImage == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              final XFile? file = await _pickImageFromGallery();
                              setState(() {
                                goal.photoUrl = file!.path;
                              });
                            },
                            child: const Text('Choose from Gallery'),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () async {
                              final XFile? file = await _pickImageFromCamera();
                              setState(() {
                                goal.photoUrl = file!.path;
                              });
                            },
                            child: const Text('Take a Photo'),
                          ),
                        ],
                      )
                    : Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Image.file(
                            _selectedImage!,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _selectedImage = null;
                              });
                            },
                            icon: const Icon(
                              Icons.cancel,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
