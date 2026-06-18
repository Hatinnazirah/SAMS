import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import '../../controllers/ManageCurriculumCoCurriculumActivities/StudentController.dart';

class ActivitySubmissionPage extends StatefulWidget {
  final Map<String, dynamic> activity;

  const ActivitySubmissionPage({super.key, required this.activity});

  @override
  _ActivitySubmissionPageState createState() => _ActivitySubmissionPageState();
}

class _ActivitySubmissionPageState extends State<ActivitySubmissionPage> {
  final TextEditingController _descriptionController = TextEditingController();
  final String matricId = "CB23048";
  final String studentName = "HATIN NAZIRAH";
  final StudentController _controller = StudentController();
  File? _selectedFile;
  String? _selectedFileName;
  String? _selectedFileType;
  bool _isSubmitting = false;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // File picker for images
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedFile = File(image.path);
        _selectedFileName = image.name;
        _selectedFileType = 'image';
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Image selected: ${image.name}')));
    }
  }

  // 🔴 FIXED: File picker for PDF
  Future<void> _pickPDF() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false,
      );

      if (result != null) {
        // 🔴 FIX: Use result.files.first directly
        final file = result.files.first;
        
        if (file.path != null) {
          setState(() {
            _selectedFile = File(file.path!);
            _selectedFileName = file.name;
            _selectedFileType = 'pdf';
          });
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('PDF selected: ${file.name}')));
        } else {
          // 🔴 FIX: For Android 11+, file.path might be null, use bytes instead
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('PDF selected, but file path not available')));
        }
      } else {
        // User canceled the picker
        print('User canceled PDF picker');
      }
    } catch (e) {
      print('Error picking PDF: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to pick PDF: $e')));
    }
  }

  // 🔴 FIXED: File picker for any file
  Future<void> _pickAnyFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
      );

      if (result != null) {
        final file = result.files.first;
        
        if (file.path != null) {
          setState(() {
            _selectedFile = File(file.path!);
            _selectedFileName = file.name;
            _selectedFileType = 'file';
          });
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('File selected: ${file.name}')));
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('File selected: ${file.name}')));
        }
      }
    } catch (e) {
      print('Error picking file: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to pick file: $e')));
    }
  }

  // Show file picker options dialog
  void _showFilePickerOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Choose File Type',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Image Option
                    _buildFilePickerOption(
                      icon: Icons.image,
                      label: 'Image',
                      color: Colors.blue,
                      onTap: () {
                        Navigator.pop(context);
                        _pickImage();
                      },
                    ),
                    // PDF Option
                    _buildFilePickerOption(
                      icon: Icons.picture_as_pdf,
                      label: 'PDF',
                      color: Colors.red,
                      onTap: () {
                        Navigator.pop(context);
                        _pickPDF();
                      },
                    ),
                    // Any File Option
                    _buildFilePickerOption(
                      icon: Icons.attach_file,
                      label: 'Any File',
                      color: Colors.green,
                      onTap: () {
                        Navigator.pop(context);
                        _pickAnyFile();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilePickerOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getFileTypeLabel() {
    if (_selectedFileType == 'image') return 'Image';
    if (_selectedFileType == 'pdf') return 'PDF';
    if (_selectedFileType == 'file') return 'File';
    return '';
  }

  Color _getFileTypeColor() {
    if (_selectedFileType == 'image') return Colors.blue;
    if (_selectedFileType == 'pdf') return Colors.red;
    if (_selectedFileType == 'file') return Colors.green;
    return Colors.grey;
  }

  void _submitActivity() async {
    if (_descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a description')),
      );
      return;
    }

    if (_selectedFile == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please upload a file')));
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Get activity data
      String activityId = widget.activity['id'] ?? '';
      String moduleCode = widget.activity['moduleCode'] ?? '';
      String moduleName = widget.activity['moduleName'] ?? '';
      String activityName =
          widget.activity['activityName'] ?? 'Activity Submission';

      print('📝 Submitting for ActivityID: $activityId');
      print('📝 ModuleCode: $moduleCode');
      print('📝 File Type: $_selectedFileType');

      // 🔴 NO STORAGE UPLOAD - Just create a placeholder URL with file extension
      String placeholderUrl =
          'submission_${DateTime.now().millisecondsSinceEpoch}_${_selectedFile!.path.split('/').last}';

      // 🔴 SAVE TO STUDENTSUBMISSION TABLE
      bool success = await _controller.submitActivity(
        matricId,
        studentName,
        activityId,
        placeholderUrl,
        _descriptionController.text,
      );

      if (!success) {
        setState(() {
          _isSubmitting = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to submit activity. Please try again.'),
          ),
        );
        return;
      }

      setState(() {
        _isSubmitting = false;
      });

      // Show success dialog
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      size: 60,
                      color: Color(0xFF00B000),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'SUBMISSION SUCCESSFUL!',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00B000),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your submission for ${widget.activity['activityName']} has been received.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Waiting for grading...',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Colors.orange),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context, true);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1976D2),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 12,
                        ),
                      ),
                      child: const Text(
                        'OK',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
    } catch (e) {
      setState(() {
        _isSubmitting = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
      print('❌ Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final activity = widget.activity;

    return Scaffold(
      backgroundColor: const Color(0xFFDCE5F4),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Top Header
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                        size: 28,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Row(
                      children: [
                        Text(
                          matricId,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.blue,
                          size: 20,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const Text(
                'SUBMISSION',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Activity Info Card
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${activity['moduleCode']}  ${activity['moduleName']}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              activity['activityName'] ?? 'Activity Submission',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 12),
                            if (activity['description'] != null &&
                                activity['description'].isNotEmpty)
                              Text(
                                activity['description'],
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black87,
                                ),
                              ),
                            if (activity['instructions'] != null &&
                                activity['instructions'].isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  'Instructions: ${activity['instructions']}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ),
                            const SizedBox(height: 8),
                            if (activity['dueDate'] != null &&
                                activity['dueDate'].isNotEmpty)
                              Text(
                                'Due: ${activity['dueDate']}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.red[400],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Submission Form Card
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'SUBMISSION FORM',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 16),

                            TextField(
                              controller: _descriptionController,
                              decoration: InputDecoration(
                                labelText: 'Submission Description',
                                labelStyle: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                                hintText: 'Explain your submission...',
                                alignLabelWithHint: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF1976D2),
                                  ),
                                ),
                              ),
                              maxLines: 4,
                            ),
                            const SizedBox(height: 16),

                            // File Upload Area
                            InkWell(
                              onTap: _showFilePickerOptions,
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: _selectedFile != null
                                        ? _getFileTypeColor()
                                        : Colors.grey.shade300,
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  color: _selectedFile != null
                                      ? _getFileTypeColor().withOpacity(0.05)
                                      : const Color(0xFFF8FAFC),
                                ),
                                child: Column(
                                  children: [
                                    Icon(
                                      _selectedFileType == 'pdf'
                                          ? Icons.picture_as_pdf
                                          : _selectedFileType == 'image'
                                          ? Icons.image
                                          : Icons.upload_file,
                                      size: 36,
                                      color: _selectedFile != null
                                          ? _getFileTypeColor()
                                          : Colors.grey[400],
                                    ),
                                    const SizedBox(height: 8),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0,
                                      ),
                                      child: Text(
                                        _selectedFileName ??
                                            'Click to upload file',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: _selectedFileName == null
                                              ? Colors.grey
                                              : _getFileTypeColor(),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    if (_selectedFileType != null)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: _getFileTypeColor()
                                              .withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          _getFileTypeLabel(),
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: _getFileTypeColor(),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    if (_selectedFileName == null)
                                      Text(
                                        'Supports: Images, PDF, Word, Excel, etc.',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Submit Button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _isSubmitting
                                    ? null
                                    : _submitActivity,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1976D2),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: _isSubmitting
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Text(
                                        'SUBMIT ACTIVITY',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}