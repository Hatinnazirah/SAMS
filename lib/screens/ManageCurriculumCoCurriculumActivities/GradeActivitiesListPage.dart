import 'package:flutter/material.dart';
import '../../controllers/ManageCurriculumCoCurriculumActivities/PusatAdabController.dart';

class GradeActivitiesListPage extends StatefulWidget {
  final String moduleId;
  final String moduleCode;
  final String moduleName;
  final List<Map<String, dynamic>> submissions;

  const GradeActivitiesListPage({
    super.key,
    required this.moduleId,
    required this.moduleCode,
    required this.moduleName,
    required this.submissions,
  });

  @override
  _GradeActivitiesListPageState createState() => _GradeActivitiesListPageState();
}

class _GradeActivitiesListPageState extends State<GradeActivitiesListPage> {
  final PusatAdabController _controller = PusatAdabController();
  final String staffId = "PUSAT ADAB";
  
  late List<Map<String, dynamic>> _submissions;

  @override
  void initState() {
    super.initState();
    _submissions = List.from(widget.submissions);
  }

  void _viewDocument(String documentUrl) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Document'),
        content: Text('Viewing: $documentUrl\n\nDemo: Document viewer would open here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _downloadDocument(String documentUrl) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Downloading: $documentUrl (Demo)')),
    );
  }

  void _openGradingDialog(Map<String, dynamic> submission) {
    final TextEditingController scoreController = TextEditingController();
    final String submissionId = submission['submissionId']?.toString() ?? '';
    final String studentName = submission['studentName']?.toString().toUpperCase() ?? '';
    final String studentId = submission['studentId']?.toString() ?? '';
    final String documentUrl = submission['documentUrl'] ?? 'Assignment1.pdf';

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'GRADE',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                studentName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                studentId,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Uploaded File: $documentUrl',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 16),
              
              // Total Marks Input
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Total Marks: ',
                    style: TextStyle(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    width: 50,
                    height: 30,
                    child: TextField(
                      controller: scoreController,
                      autofocus: true,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF009639), width: 2),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black.withOpacity(0.25)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Submit Button
              SizedBox(
                height: 36,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF009639),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  onPressed: () async {
                    final score = int.tryParse(scoreController.text);
                    if (score == null || score < 0 || score > 100) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter a score between 0 and 100')),
                      );
                      return;
                    }
                    Navigator.pop(context);
                    
                    bool success = await _controller.validateAndUpdateScoreData(
                      submissionId, 
                      score, 
                      "STAFF001"
                    );
                    
                    if (success) {
                      setState(() {
                        // Update local submission status
                        final index = _submissions.indexWhere((s) => s['submissionId'] == submissionId);
                        if (index != -1) {
                          _submissions[index]['isGraded'] = true;
                          _submissions[index]['score'] = score;
                        }
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Grade successfully submitted for $studentName!')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Failed to submit grade. Please try again.')),
                      );
                    }
                  },
                  child: const Text('SUBMIT', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDCE5F4),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black, size: 26),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        staffId,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const Icon(Icons.keyboard_arrow_down, size: 18, color: Colors.blue),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            const Text(
              'GRADE ACTIVITY',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${widget.moduleCode} ${widget.moduleName.toUpperCase()}',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 20),

            // Submissions List
            Expanded(
              child: _submissions.isEmpty
                  ? const Center(
                      child: Text(
                        'No submissions for this module',
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      itemCount: _submissions.length,
                      itemBuilder: (context, index) {
                        final submission = _submissions[index];
                        final bool isGraded = submission['isGraded'] ?? false;
                        
                        return Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF2F5FA),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                submission['studentName']?.toString().toUpperCase() ?? '',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                submission['studentId'] ?? '',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Activity: ${submission['activityName'] ?? ''}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                              if (isGraded && submission['score'] != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    'Score: ${submission['score']}/100',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.teal,
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 16),
                              
                              // Buttons Row
                              Row(
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      height: 36,
                                      child: ElevatedButton(
                                        onPressed: () => _viewDocument(submission['documentUrl'] ?? ''),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF1570CD),
                                          foregroundColor: Colors.white,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                          padding: EdgeInsets.zero,
                                        ),
                                        child: const Text('VIEW', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  
                                  Expanded(
                                    child: SizedBox(
                                      height: 36,
                                      child: ElevatedButton(
                                        onPressed: () => _downloadDocument(submission['documentUrl'] ?? ''),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF7A7A7A),
                                          foregroundColor: Colors.white,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                          padding: EdgeInsets.zero,
                                        ),
                                        child: const Text('DOWNLOAD', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  
                                  Expanded(
                                    child: SizedBox(
                                      height: 36,
                                      child: ElevatedButton(
                                        onPressed: isGraded 
                                            ? null
                                            : () => _openGradingDialog(submission),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: isGraded 
                                              ? const Color(0xFF7A7A7A)
                                              : const Color(0xFF009639),
                                          foregroundColor: Colors.white,
                                          disabledBackgroundColor: const Color(0xFF7A7A7A),
                                          disabledForegroundColor: Colors.white70,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                          padding: EdgeInsets.zero,
                                        ),
                                        child: Text(
                                          isGraded ? 'GRADED' : 'GRADE', 
                                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}