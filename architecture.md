# CarePilot - Telemedicine App Architecture

## Overview
A modern telemedicine application that allows patients to connect with doctors for remote consultations, symptom diagnosis, and treatment recommendations.

## Core Features (MVP)
1. **Home Dashboard** - Quick access to book consultations, view upcoming appointments
2. **Doctor Directory** - Browse and search available doctors by specialty
3. **Appointment Booking** - Schedule video consultations with doctors
4. **Symptom Checker** - Input symptoms and get preliminary guidance
5. **Patient Profile** - Manage personal and medical information
6. **Appointment History** - View past consultations and prescriptions

## Design Principles
- Modern, sleek UI with medical-themed colors (teal, soft blue, white)
- Generous spacing and padding for a clean, uncluttered look
- Elegant fonts (Inter font family)
- Smooth transitions and subtle animations
- Avoid typical Material Design, focus on custom, polished components

## Data Models (lib/models/)
1. **User** - Patient profile information
   - id, name, email, phone, dateOfBirth, gender, bloodType, allergies, medicalHistory
   - created_at, updated_at
   
2. **Doctor** - Doctor profile information
   - id, name, specialty, experience, rating, availability, imageUrl, about, consultationFee
   - created_at, updated_at
   
3. **Appointment** - Consultation bookings
   - id, patientId, doctorId, dateTime, status, type, symptoms, notes
   - created_at, updated_at
   
4. **Symptom** - Symptom tracking
   - id, userId, symptoms, severity, duration, notes
   - created_at, updated_at

## Service Classes (lib/services/)
1. **UserService** - Manage user data operations (local storage with sample data)
2. **DoctorService** - Manage doctor listings (local storage with sample data)
3. **AppointmentService** - Manage appointment bookings (local storage with sample data)
4. **SymptomService** - Manage symptom tracking (local storage with sample data)

## Screen Structure (lib/screens/)
1. **HomePage** - Dashboard with quick actions and upcoming appointments
2. **DoctorsPage** - List of available doctors with search/filter
3. **DoctorDetailPage** - Detailed doctor profile and booking option
4. **BookAppointmentPage** - Schedule a consultation
5. **SymptomCheckerPage** - Enter symptoms for preliminary assessment
6. **ProfilePage** - View/edit patient profile
7. **AppointmentHistoryPage** - Past and upcoming appointments

## Widgets (lib/widgets/)
1. **CustomButton** - Reusable styled button component
2. **DoctorCard** - Card displaying doctor information
3. **AppointmentCard** - Card showing appointment details
4. **SymptomInputField** - Custom input for symptom entry
5. **ProfileInfoTile** - Display profile information sections

## Theme & Colors
- Primary: Teal/Cyan (#00ACC1, #00BCD4)
- Secondary: Soft Blue (#4FC3F7, #29B6F6)
- Accent: Warm accent color (#FF6B6B)
- Background: White (#FFFFFF) and light gray (#F5F7FA)
- Text: Dark blue-gray (#1A237E, #455A64)
- Success: Green (#4CAF50)

## Implementation Steps
1. Update theme.dart with modern medical-themed colors
2. Create all data models with toJson, fromJson, copyWith methods
3. Create service classes with local storage and sample data
4. Implement HomePage with dashboard UI
5. Implement DoctorsPage with doctor listing
6. Implement DoctorDetailPage with booking functionality
7. Implement BookAppointmentPage for scheduling
8. Implement SymptomCheckerPage for symptom input
9. Implement ProfilePage for patient information
10. Implement AppointmentHistoryPage for viewing consultations
11. Create reusable widget components
12. Add navigation between screens
13. Run compile_project to validate implementation

## Dependencies Required
- google_fonts (already included)
- shared_preferences (for local storage)
- intl (for date/time formatting)
- url_launcher (for potential phone/email links)
