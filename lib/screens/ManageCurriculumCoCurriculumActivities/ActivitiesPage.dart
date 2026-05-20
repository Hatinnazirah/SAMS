import 'package:flutter/material.dart';
import 'ActivitySubmissionPage.dart';

class ActivitiesPage extends StatefulWidget {
  @override
  _ActivitiesPageState createState() => _ActivitiesPageState();
}

class _ActivitiesPageState extends State<ActivitiesPage> {
  final String matricId = "CB23048";
  bool _isLoading = false;
  
  List<Map<String, dynamic>> _activities = [
    {
      'id': '1',
      'moduleCode': 'HQD3062',
      'moduleName': 'EDIT LIKE A PRO WITH CANVA',
      'activityName': 'Creative Poster Design Assignment',
      'openedDate': '21/12/2024',
      'dueDate': '28/12/2024',
      'status': 'pending',
      'description': 'Create a creative poster using Canva. Theme: Environmental Awareness',
      'instructions': 'Submit your poster in PDF format. Include your name and matrix number.',
    },
    {
      'id': '2',
      'moduleCode': 'UHS1221',
      'moduleName': 'THEATRE',
      'activityName': 'Acting & Performance Reflection',
      'openedDate': '21/12/2024',
      'dueDate': '28/12/2024',
      'status': 'pending',
      'description': 'Write a reflection on your acting performance',
      'instructions': 'Submit in DOC or PDF format, minimum 500 words.',
    },
    {
      'id': '3',
      'moduleCode': 'HQS3012',
      'moduleName': 'ASAS CATUR',
      'activityName': 'Chess Gameplay Report',
      'openedDate': '21/12/2024',
      'dueDate': '28/12/2024',
      'status': 'submitted',
      'description': 'Report on your chess gameplay strategies',
      'instructions': 'Submit your report with analysis of 3 games.',
    },
    {
      'id': '4',
      'moduleCode': 'HQD3022',
      'moduleName': 'MOBILE PHONE PHOTOGRAPHY',
      'activityName': 'Photo Collection Submission',
      'openedDate': '21/12/2024',
      'dueDate': '28/12/2024',
      'status': 'submitted',
      'description': 'Submit 5 photos with theme "Nature"',
      'instructions': 'Photos must be original and high resolution.',
    },
  ];

  // Method to update activity status when coming back from submission
  void _updateActivityStatus(String activityId) {
    setState(() {
      final index = _activities.indexWhere((a) => a['id'] == activityId);
      if (index != -1) {
        _activities[index]['status'] = 'submitted';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDCE5F4),
      body: SafeArea(
        child: Column(
          children: [
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
                          child: Text(
                            'No activities assigned',
                            style: TextStyle(fontSize: 16, color: Colors.black54),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          itemCount: _activities.length,
                          itemBuilder: (context, index) {
                            final activity = _activities[index];
                            final isSubmitted = activity['status'] == 'submitted';
                            
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
                                            activity['activityName'],
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Opened: Saturday, ${activity['openedDate']}, 11:59 PM',
                                            style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            'Due: Saturday, ${activity['dueDate']}, 11:59 PM',
                                            style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    
                                    isSubmitted
                                        ? ElevatedButton(
                                            onPressed: () {},
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(0xFF00B000),
                                              foregroundColor: Colors.white,
                                              elevation: 0,
                                              minimumSize: const Size(100, 38),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(18),
                                              ),
                                            ),
                                            child: const Text(
                                              'DONE',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13,
                                              ),
                                            ),
                                          )
                                        : ElevatedButton(
                                            onPressed: () async {
                                              final result = await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => ActivitySubmissionPage(
                                                    activity: activity,
                                                  ),
                                                ),
                                              );
                                              // If submission was successful, update status
                                              if (result == true) {
                                                _updateActivityStatus(activity['id']);
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(0xFF1976D2),
                                              foregroundColor: Colors.white,
                                              elevation: 0,
                                              minimumSize: const Size(130, 38),
                                              padding: const EdgeInsets.symmetric(horizontal: 10),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(18),
                                              ),
                                            ),
                                            child: const Text(
                                              'ADD SUBMISSION',
                                              style: TextStyle(
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
          ],
        ),
      ),
    );
  }
}