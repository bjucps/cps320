import 'package:flutter/material.dart';

// Router Constants
const startScreenPath = "/";
const homeScreenPath = "/home";
const calendarScreenPath = "/home/calendar";
const linkBankScreenPath = "/home/linkBank";
const deepLinkEventPath = "events";
const uriScheme = 'edu.bju.arts-and-culture';
const eventDetailsPath = "/events/:eventId";
const pamphletViewPath = "/events/:eventId/:pamphletId";
const uploadedPamphletViewPath = "/events/:eventId/pamphlet_pdf/:pamphletId";

// QR Scanner Constants
const qrScannerPath = "/home/scan";
const qrNotRecognized = 'Not a valid event QR code.';
const scanInstruction = 'Point camera at an event QR code';
const checkInSuccessTitle = 'Checked In!';
const checkInSuccessMessage = 'Your attendance has been recorded.';
const checkInErrorTitle = 'Check-In Failed';
const semesterAttendedLabel = 'Semester attendances:';
const alreadyAttendedTitle = 'Already Attended';
const alreadyAttendedMessage =
    'You are already marked as attended for this event.';

// Calendar/Event Constants
const calendarTitle = "Calendar";
const eventCalendarTitle = "Events Calendar";
const eventDetailsTitle = "Event Details";
const pamphletTitle = "Event Program";
const viewPamphletButtonText = "Tap to view PDF";
const noPamphletsText = "No programs are available for this event.";
const dateFormat = "MMM d, yyyy";
const timeFormat = "HH:mm:ss";

// Home Page Constants
const homeTitle = "Home";
const calendarButton = "Calendar";
const logoutButton = "Logout";
const linkBankButton = "Links";
const attendButton = "Attendance";
const feedbackButton = "Feedback";
const aboutButton = "About";
const guestNotice = "Browsing as guest. Sign in for attendance & classes.";
const guestLogin = "Sign In with BJU Account";
const homeWidgetText1 = "Arts & Culture at BJU";
const homeWidgetText3 = "Upcoming Events";
const homeWidgetEventError = "Could not load events right now.";
const feedbackURL =
    "https://forms.cloud.microsoft/Pages/ResponsePage.aspx?id=mix9Z05i_k6JWO41pxwNcWPJx7Oql69KhUJEnB8ZLYJUQklSM1ZIUDRGQTVLR1g4MzZMM1A3Qkk1Ui4u";
const aboutDialogTitle = "About The App";
const aboutAppName = "Arts & Culture At BJU";
const aboutCopyright = "Copyright © BJU, Inc.";
const aboutSupportLabel = "Support";
const aboutSupportValue = "Use the Feedback link to report any issues.";
const aboutPurpose =
    "Dr. Michael Moore and Mrs. Emily Waggoner proposed a unified mobile app for Fine Arts events at Bob Jones University. The app combines event programs, attendance tracking, and event notifications into a single platform to simplify event management and improve accessibility for attendees. This app was developed by the students of the Mobile & Distributed App Development class of the 2026 Spring Semester with the backend starting point from the students of the Software Engineering class of the Fall 2025 semester.";
const aboutDevelopersTitle = "Main App Developers";
const aboutBackendTitle = "Backend Developers";
const aboutFacultyAdvisorTitle = "Faculty Advisor";
const aboutSponsorsTitle = "School of Fine Arts & Communication Sponsors";
const aboutGraphicDesignTitle = "Logo Design";
const List<String> aboutDevelopers = <String>[
  "Samuel Ayers",
  "Tessa Bonnema",
  "Titus Li",
  "Joel Logan",
  "John Tam",
  "Andrew Wester",
  "Josiah Zempel",
];

var aboutDevColors = {
  aboutDevelopers[0]: Color(0xFF228B22),
  aboutDevelopers[1]: Color(0xFF007BA7),
  aboutDevelopers[2]: Color(0xFFADD8E6),
  aboutDevelopers[3]: Color(0xFF800080),
  aboutDevelopers[4]: Color(0xFF87CEEB),
  aboutDevelopers[5]: Color(0xFF00C356),
  aboutDevelopers[6]: Color(0xFFFF0000),
};

const List<String> aboutBackend = <String>[
  "Briggs Estelle, Ben Ewing, Ryan Kuhn, Daniel Malabanti, Joshua Smith, Martin Song, Andrew Wester, Jin Yoo, Josiah Zempel",
];
const List<String> aboutFacultyAdvisors = <String>["Dr. Sarah Gothard"];
const List<String> aboutFineArtsCommSponsors = <String>[
  "Dr. Michael Moore",
  "Mrs. Emily Waggoner",
];
const List<String> aboutGraphicDesigners = <String>["Kathryn Kuchle"];
const musicLogo = "assets/Departmental_Logo_Music_Short.png";
const musicDarkLogo = "assets/Departmental_Logo_Music-White_Short.png";
const pamphletCrestLogo = "assets/Departmental_Logo_Music_BW.png";
const homeBkrndImageLoc = "assets/home_background.jpg";

// Attendance/Class screen
const myClassesScreenPath = '/attendance';
const myClassesTitle = 'My Event Attendance';
const myClassesButton = 'Attendance';
const noClassesMessage = 'You are not enrolled in any classes yet.';
const noRequiredEventsMessage = 'No required events assigned yet.';
const requirementMetLabel = 'Requirement Met ✓';
const requirementNotMetLabel = 'In Progress';

// Link Bank Page Constants
const linkBankTitle = "Links";
const giveURL = "https://give.bju.edu/how-to-give/patron/";
const giveLink = "Give";
const faCommURL =
    "https://www.bju.edu/academics/college-and-schools/fine-arts/";
const faCommLink = "Fine Arts Events";
// const applyURL = "https://music.bju.edu/apply/";
// const applyLink = "Apply";
const visitURL = "https://www.bju.edu/admission/visit/";
const visitLink = "Visit";
const showpassURL = "https://www.showpass.com/o/bjutickets/";
const showpassLink = "Showpass";

// Main Constants
const title = "Arts & Culture";

// Start Screen Constants
const loginFailure = "Login failed or was cancelled.";
const appbarTitle = "Bob Jones University";
const bkrndImageLoc = "assets/background.png";
const loginButtonText = "Login";

// Brand Colors
const brandDarkBlue = Color(0xFF001B41);
const brandDarkBlueLight = Color(0xFF606A8A);
const brandColumbiaBlue = Color(0xFF42B4ED);
const brandColumbiaBlueSoft = Color(0xFF8ED5F5);
const brandBrown = Color(0xFF884A1C);
const brandSandstorm = Color(0xFFE3D8B4);
const brandBlueGray = Color(0xFF3E465A);
const brandRedAccent = Color(0xFFE45439);
const brandLightBlueTint = Color(0xFFC6E9FA);

// Auth Service Constants
const flutterClientId = '85cb04bd-441b-495b-a3eb-4393e580255a';
const djangoClientId = 'a49279fb-02ad-40b6-8f64-ec5611244bef';
const tenantId = '677d2c9a-624e-4efe-8958-ee35a71c0d71';
const redirectUrl = 'edu.bju.arts-and-culture://login-callback/';
const issuer = 'https://login.microsoftonline.com/$tenantId/v2.0';

// titles
const checkInTitle = 'Check In';
const scanQRText = 'Scan QR';
const scanEventQR = 'Scan Event QR';
const scanned = 'Scanned';

// errors
const couldNotLaunch = 'Could not launch';
const startupAuthErrMsg = 'Startup Auth Check Error';

// API constants
const baseUrl = 'https://duo.bjucps.dev';

// Guest login
const renewThresholdDays = 7;
const guestLoginScreenPath = '/guest-login';
const guestLoginRenewLink = '/api/guest-renew/';
const guestLoginLink = '/api/guest-login';
const guestLoginTitle = 'Guest Access';
const guestLoginSubtitle = 'Continue without a BJU account';
const guestLoginDescription =
    'Guest access lets you browse events and explore the app.\n'
    'Sign in with your BJU account for full features like attendance.';
const guestLoginButtonText = 'Open Verification Page';
const guestContinueText = 'Continue as Guest';
const guestAppToken = 'bju-arts-flutter';
const guestDeepLinkUrl = 'bju-arts-and-culture';
const guestKeyExpiryDays = 7;

//themes
final ThemeData appLightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    onPrimary: brandDarkBlue,
    secondary: brandSandstorm,
    onSecondary: brandBrown,
    onSecondaryFixed: brandDarkBlueLight,
  ),
);
final ThemeData appDarkTheme = ThemeData(
  // brightness: Brightness.dark,
  colorScheme: ColorScheme.dark().copyWith(
    onPrimary: brandColumbiaBlue,
    secondary: brandDarkBlue,
    onSecondary: Colors.white,
    onSecondaryFixed: brandColumbiaBlueSoft,
  ),
);
