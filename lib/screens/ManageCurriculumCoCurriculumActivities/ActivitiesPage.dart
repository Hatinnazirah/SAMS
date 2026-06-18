import 'package:flutter/material.dart';
import '../../controllers/ManageCurriculumCoCurriculumActivities/StudentController.dart';
import 'ActivitySubmissionPage.dart';

class ActivitiesPage extends StatefulWidget {
  @override
  _ActivitiesPageState createState() => _ActivitiesPageState();
}

class _ActivitiesPageState extends State<ActivitiesPage> {
  final StudentController _controller = StudentController();
  final String matricId = "CB23048";
  bool _isLoading = true;
  
  List<Map<String, dynamic>> _activities = [];

  @override
  void initState() {
    super.initState();
    _loadActivities();
  }

  Future<void> _loadActivities() async {
    setState(() => _isLoading = true);
    print("🔴🔴🔴 Loading activities for student: $matricId");
    _activities = await _controller.getAssignedActivities(matricId);
    print("🔴🔴🔴 Activities loaded: ${_activities.length}");
    for (var activity in _activities) {
      print("🔴🔴🔴 Activity: ${activity['moduleCode']} - ${activity['moduleName']} - ${activity['activityName']} - Status: ${activity['status']} - Score: ${activity['score']}");
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDCE5F4),
      body: SafeArea(
        child: Column(
          children: [
            // Top Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
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
                      const Icon(Icons.keyboard_arrow_down, color: Colors.blue, size: 20),
                    ],
                  ),
                ],
              ),
            ),
            
            const Text(
              'ACTIVITIES',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _activities.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.assignment_outlined, size: 60, color: Colors.grey),
                              SizedBox(height: 16),
                              Text(
                                'No activities assigned',
                                style: TextStyle(fontSize: 16, color: Colors.black54),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Please register for modules first',
                                style: TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _loadActivities,
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            itemCount: _activities.length,
                            itemBuilder: (context, index) {
                              final activity = _activities[index];
                              
                              // Status logic
                              final isSubmitted = activity['status'] == 'submitted';
                              final isGraded = activity['status'] == 'graded';
                              final isNotStarted = activity['status'] == 'not_started';
                              final score = activity['score'];
                              
                              String buttonText = 'ADD SUBMISSION';
                              Color buttonColor = const Color(0xFF1976D2);
                              bool buttonEnabled = true;
                              
                              if (isGraded) {
                                buttonText = 'GRADED ✓';
                                buttonColor = const Color(0xFF00B000);
                                buttonEnabled = false;
                              } else if (isSubmitted) {
                                buttonText = 'PENDING';
                                buttonColor = const Color(0xFFFF9200);
                                buttonEnabled = false;
                              } else if (isNotStarted) {
                                buttonText = 'ADD SUBMISSION';
                                buttonColor = const Color(0xFF1976D2);
                                buttonEnabled = true;
                              }
                              
                              return Container(
                                margin: const EdgeInsets.only(bottom: 16),
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
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
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
                                            const SizedBox(height: 4),
                                            Text(
                                              activity['activityName'] ?? 'Activity Submission',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            if (activity['openedDate'] != null && activity['openedDate'].isNotEmpty)
                                              Text(
                                                'Opened: ${activity['openedDate']}',
                                                style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                                              ),
                                            if (activity['dueDate'] != null && activity['dueDate'].isNotEmpty)
                                              Text(
                                                'Due: ${activity['dueDate']}',
                                                style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                                              ),
                                            // Show score if graded
                                            if (isGraded && score != null)
                                              Text(
                                                'Score: $score/100',
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.teal,
                                                ),
                                              ),
                                            if (isSubmitted)
                                              const Text(
                                                'Waiting for grading...',
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontStyle: FontStyle.italic,
                                                  color: Colors.orange,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      
                                      ElevatedButton(
                                        onPressed: buttonEnabled
                                            ? () async {
                                                final result = await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => ActivitySubmissionPage(
                                                      activity: activity,
                                                    ),
                                                  ),
                                                );
                                                if (result == true) {
                                                  _loadActivities();
                                                }
                                              }
                                            : null,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: buttonColor,
                                          foregroundColor: Colors.white,
                                          elevation: 0,
                                          minimumSize: const Size(130, 38),
                                          padding: const EdgeInsets.symmetric(horizontal: 10),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(18),
                                          ),
                                          disabledBackgroundColor: buttonColor,
                                          disabledForegroundColor: Colors.white,
                                        ),
                                        child: Text(
                                          buttonText,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}