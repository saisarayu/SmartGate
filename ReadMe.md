# Smart Gate – Digital Visitor Management System (Flutter-Based)

## 1. Project Overview
Smart Gate is a mobile-based Digital Visitor Management System designed to replace handwritten visitor registers in gated residential communities. The system improves security, efficiency, and record management by digitizing visitor entry, approval, and exit tracking using a Flutter mobile application integrated with a backend server.

The system connects three main users:
- **Visitor**
- **Security Guard**
- **Resident**

## 2. Problem Statement
Traditional visitor management in residential communities relies on manual logbooks. This approach has major limitations:
- Fake or incorrect visitor information
- No identity verification
- No real-time approval from residents
- Difficult to search historical records
- No analytics or security alerts
- Poor tracking of entry and exit times

This leads to security risks and operational inefficiencies.

## 3. Proposed Solution
Smart Gate provides a digital, secure, and real-time visitor management system using a Flutter mobile application.
The system includes:
- Digital visitor registration
- OTP-based phone verification
- Resident approval through mobile notification
- QR-based entry and exit tracking
- Blacklist and alert system
- Real-time visitor status updates
- Secure data storage and reporting

## 4. System Architecture
The system consists of:
### A. Mobile Application (Flutter)
Used by Security Guards and Residents.
### B. Backend Server
Built using Node.js + Express. Handles business logic, authentication, and APIs.
### C. Database
MongoDB. Stores user data, visitor records, and logs.
### D. Third-Party Integrations
- SMS Gateway for OTP verification
- Firebase Cloud Messaging (FCM) for push notifications
- Camera API for visitor photo capture
- QR Code generation and scanning

## 5. User Roles and Responsibilities
### 1. Security Guard
- Login and Register visitor details
- Send OTP for verification
- Capture visitor photo
- Send entry request to resident
- Mark check-in and check-out
- View blacklist alerts

### 2. Resident
- Login and Receive visitor request notifications
- Approve or reject entry
- View visitor history

### 3. Visitor
- Provide details at the gate
- Verify phone number via OTP
- Show QR code for entry (if pre-approved)

## 6. System Workflow
1. Visitor arrives at the gate.
2. Guard enters visitor details in the Flutter app.
3. System sends OTP to visitor’s phone.
4. Visitor verifies OTP.
5. Resident receives push notification.
6. Resident approves or rejects request.
7. Guard marks check-in.
8. Guard marks check-out when visitor exits.
9. All data is stored securely in the database.

## 7. Key Features
- Role-based authentication using JWT
- Secure OTP verification
- Push notifications in real time
- QR code-based digital pass
- Visitor photo capture
- Blacklist management
- Reports and analytics
- Searchable visitor history

## 8. Advantages
- Eliminates manual register errors
- Improves security through verification
- Provides digital record keeping
- Enables faster approval process
- Supports real-time monitoring
- Scalable for large residential communities

## 9. Future Enhancements
- Face recognition integration
- CCTV integration
- Automated boom barrier control
- AI-based suspicious activity detection
- Web admin dashboard
- Cloud deployment with multi-community support

## 10. Conclusion
Smart Gate is a secure, scalable, and efficient digital solution for managing visitor entries in gated residential communities. By replacing handwritten logs with a Flutter-based mobile application integrated with backend services, the system enhances safety, transparency, and operational efficiency.