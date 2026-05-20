class PusatAdabController {
  
  // ==============================================
  // GRADE ACTIVITY METHODS
  // ==============================================
  
  // Get modules with pending submissions (for GradeActivitiesPage)
  Future<List<Map<String, dynamic>>> getSubmittedActivitiesList() async {
    await Future.delayed(Duration(seconds: 1));
    
    // Dummy data - modules with pending submissions
    return [
      {
        'moduleId': '1',
        'moduleCode': 'HQD3022',
        'moduleName': 'MOBILE PHONE PHOTOGRAPHY',
        'pendingCount': 3,
        'submissions': [
          {
            'submissionId': 'S001',
            'studentId': 'CB23048',
            'studentName': 'HATIN NAZIRAH',
            'activityName': 'Photo Collection',
            'submissionDate': '15/5/2026',
            'documentUrl': 'submission1.pdf',
          },
          {
            'submissionId': 'S002',
            'studentId': 'CB23088',
            'studentName': 'NUR ADILAH',
            'activityName': 'Photo Collection',
            'submissionDate': '16/5/2026',
            'documentUrl': 'submission2.pdf',
          },
        ],
      },
      {
        'moduleId': '2',
        'moduleCode': 'HQP3022',
        'moduleName': 'PENGURUSAN MAJLIS',
        'pendingCount': 2,
        'submissions': [
          {
            'submissionId': 'S003',
            'studentId': 'CB23058',
            'studentName': 'AININ QISTINA',
            'activityName': 'Event Report',
            'submissionDate': '14/5/2026',
            'documentUrl': 'submission3.pdf',
          },
        ],
      },
      {
        'moduleId': '3',
        'moduleCode': 'HQR3022',
        'moduleName': 'PSYCHOLOGICAL FIRST AID',
        'pendingCount': 1,
        'submissions': [
          {
            'submissionId': 'S004',
            'studentId': 'CB24025',
            'studentName': 'SITI NURNI AFRINA',
            'activityName': 'Reflection Paper',
            'submissionDate': '17/5/2026',
            'documentUrl': 'submission4.pdf',
          },
        ],
      },
      {
        'moduleId': '4',
        'moduleCode': 'HQD3062',
        'moduleName': 'EDIT LIKE A PRO WITH CANVA',
        'pendingCount': 4,
        'submissions': [
          {
            'submissionId': 'S005',
            'studentId': 'CB23048',
            'studentName': 'HATIN NAZIRAH',
            'activityName': 'Poster Design',
            'submissionDate': '18/5/2026',
            'documentUrl': 'submission5.pdf',
          },
        ],
      },
      {
        'moduleId': '5',
        'moduleCode': 'HQS3012',
        'moduleName': 'ASAS CATUR',
        'pendingCount': 2,
        'submissions': [],
      },
      {
        'moduleId': '6',
        'moduleCode': 'UHS1221',
        'moduleName': 'THEATRE',
        'pendingCount': 1,
        'submissions': [],
      },
      {
        'moduleId': '7',
        'moduleCode': 'UHS1241',
        'moduleName': 'VISUAL ARTS',
        'pendingCount': 3,
        'submissions': [],
      },
      {
        'moduleId': '8',
        'moduleCode': 'UHS1411',
        'moduleName': 'COMMUNITY SERVICE',
        'pendingCount': 2,
        'submissions': [],
      },
      {
        'moduleId': '9',
        'moduleCode': 'UHS1811',
        'moduleName': 'ROBOTICS CLUB',
        'pendingCount': 1,
        'submissions': [],
      },
      {
        'moduleId': '10',
        'moduleCode': 'UHS1631',
        'moduleName': 'PUBLIC SPEAKING',
        'pendingCount': 2,
        'submissions': [],
      },
    ];
  }
  
  // SEND submittedActivitiesList to GradeActivitiesPage
  void returnSubmittedActivitiesList(List<Map<String, dynamic>> submittedActivitiesList) {
    print("Submitted activities list sent to GradeActivitiesPage");
  }
  
  // QUERY Activity table WHERE SubmissionID = SubmissionID
  // RETRIEVE DocumentURL from query result
  // FETCH document from Firebase Storage using DocumentURL
  Future<String> getViewDocument(String SubmissionID) async {
    await Future.delayed(Duration(milliseconds: 500));
    // TODO: Get document URL from Activity table
    return "document_url_here";
  }
  
  // SEND document content to ViewDocumentPage
  void returnViewDocument(String documentContent) {
    print("Document content sent to ViewDocumentPage");
  }
  
  // QUERY Activity table WHERE SubmissionID = SubmissionID
  // RETRIEVE DocumentURL from query result
  // DOWNLOAD document from Firebase Storage using DocumentURL
  Future<String> getDownloadDocument(String SubmissionID) async {
    await Future.delayed(Duration(milliseconds: 500));
    // TODO: Get download URL from Activity table
    return "download_url_here";
  }
  
  // SEND document file to GradeActivitiesListPage for local save
  void returnDownloadDocument(String documentFile) {
    print("Document file sent to GradeActivitiesListPage");
  }
  
  // IF Score >= 0 AND Score <= 100 THEN
  //   UPDATE Activity SET
  //     Score = Score,
  //     GradedBy = StaffID,
  //     GradedDate = CURRENT_TIMESTAMP,
  //     Status = 'graded'
  //   WHERE SubmissionID = SubmissionID
  // ELSE
  //   RETURN false with error message
  Future<bool> validateAndUpdateScoreData(String SubmissionID, int Score, String StaffID) async {
    await Future.delayed(Duration(seconds: 1));
    
    if (Score < 0 || Score > 100) {
      return false;
    }
    
    // TODO: Update Activity table
    returnSaveConfirmation();
    return true;
  }
  
  // RETURN "Grade submitted successfully"
  void returnSaveConfirmation() {
    print("Grade submitted successfully");
  }
  
  // ==============================================
  // VERIFY CREDIT CLAIM METHODS
  // ==============================================
  
  // QUERY CreditClaim table
  // JOIN Student to get StudentID, StudentName, StudentFaculty
  // RETURN list of claims grouped by StudentFaculty
  Future<List<Map<String, dynamic>>> getCreditClaimsList() async {
    await Future.delayed(Duration(seconds: 1));
    
    // Dummy data - faculties with pending credit claims (includes studentFaculty/program)
    return [
      {
        'facultyName': 'FACULTY OF MECHANICAL & AUTOMOTIVE ENGINEERING TECHNOLOGY',
        'pendingCount': 10,
        'claims': [
          {
            'claimId': 'C001',
            'studentId': 'CB23001',
            'studentName': 'AHMAD FAISAL',
            'studentFaculty': 'BACHELOR OF MECHANICAL ENGINEERING',
            'credits': 3,
            'claimDate': '15/5/2026',
            'status': 'pending',
          },
          {
            'claimId': 'C002',
            'studentId': 'CB23002',
            'studentName': 'NURUL AIN',
            'studentFaculty': 'BACHELOR OF AUTOMOTIVE ENGINEERING',
            'credits': 2,
            'claimDate': '16/5/2026',
            'status': 'pending',
          },
        ],
      },
      {
        'facultyName': 'FACULTY OF ELECTRICAL & ELECTRONICS ENGINEERING TECHNOLOGY',
        'pendingCount': 12,
        'claims': [
          {
            'claimId': 'C003',
            'studentId': 'CB23003',
            'studentName': 'MUHAMMAD HAFIZ',
            'studentFaculty': 'BACHELOR OF ELECTRICAL ENGINEERING',
            'credits': 1,
            'claimDate': '17/5/2026',
            'status': 'pending',
          },
          {
            'claimId': 'C004',
            'studentId': 'CB23004',
            'studentName': 'SITI AISYAH',
            'studentFaculty': 'BACHELOR OF ELECTRONICS ENGINEERING',
            'credits': 3,
            'claimDate': '18/5/2026',
            'status': 'pending',
          },
        ],
      },
      {
        'facultyName': 'FACULTY OF MANUFACTURING & MECHATRONIC ENGINEERING TECHNOLOGY',
        'pendingCount': 5,
        'claims': [
          {
            'claimId': 'C005',
            'studentId': 'CB23005',
            'studentName': 'FAIZAL BIN ALI',
            'studentFaculty': 'BACHELOR OF MECHATRONIC ENGINEERING',
            'credits': 2,
            'claimDate': '19/5/2026',
            'status': 'pending',
          },
        ],
      },
      {
        'facultyName': 'FACULTY OF COMPUTING',
        'pendingCount': 20,
        'claims': [
          {
            'claimId': 'C006',
            'studentId': 'CB23048',
            'studentName': 'HATIN NAZIRAH',
            'studentFaculty': 'BACHELOR OF COMPUTER SCIENCE (MULTIMEDIA)',
            'credits': 1,
            'claimDate': '20/5/2026',
            'status': 'pending',
          },
          {
            'claimId': 'C007',
            'studentId': 'CB23088',
            'studentName': 'NUR ADILAH',
            'studentFaculty': 'BACHELOR OF COMPUTER SCIENCE (SOFTWARE ENGINEERING)',
            'credits': 1,
            'claimDate': '21/5/2026',
            'status': 'pending',
          },
          {
            'claimId': 'C008',
            'studentId': 'CB22123',
            'studentName': 'SARAH BINTI ZAMRI',
            'studentFaculty': 'BACHELOR OF COMPUTER SCIENCE (SOFTWARE ENGINEERING)',
            'credits': 3,
            'claimDate': '22/5/2026',
            'status': 'pending',
          },
          {
            'claimId': 'C009',
            'studentId': 'CB22125',
            'studentName': 'ADAM AFIQ BIN AHMAD',
            'studentFaculty': 'BACHELOR OF COMPUTER SCIENCE (NETWORKING)',
            'credits': 3,
            'claimDate': '23/5/2026',
            'status': 'pending',
          },
          {
            'claimId': 'C010',
            'studentId': 'CB23222',
            'studentName': 'AIDA DALILAH BINTI AFFENDY',
            'studentFaculty': 'BACHELOR OF COMPUTER SCIENCE (MULTIMEDIA)',
            'credits': 3,
            'claimDate': '24/5/2026',
            'status': 'pending',
          },
        ],
      },
      {
        'facultyName': 'CENTRE FOR MODERN LANGUAGES',
        'pendingCount': 3,
        'claims': [
          {
            'claimId': 'C011',
            'studentId': 'CB23058',
            'studentName': 'AININ QISTINA',
            'studentFaculty': 'BACHELOR OF ENGLISH LANGUAGE STUDIES',
            'credits': 2,
            'claimDate': '25/5/2026',
            'status': 'pending',
          },
        ],
      },
    ];
  }
  
  // SEND creditClaimsList grouped by faculty to VerifyCreditPage
  void returnCreditClaimsList(List<Map<String, dynamic>> creditClaimsList) {
    print("Credit claims list sent to VerifyCreditPage");
  }
  
  // IF Status = 'approve' OR Status = 'reject' THEN
  //   UPDATE CreditClaim SET Status = Status
  //   WHERE ClaimID = ClaimID
  // ELSE
  //   RETURN false with error message
  Future<bool> validateAndUpdateClaimStatus(String ClaimID, String Status, String StaffID) async {
    await Future.delayed(Duration(seconds: 1));
    
    if (Status != 'approve' && Status != 'reject') {
      return false;
    }
    
    // TODO: Update CreditClaim table
    returnClaimConfirmation();
    return true;
  }
  
  // RETURN "Claim status updated successfully"
  void returnClaimConfirmation() {
    print("Claim status updated successfully");
  }
}