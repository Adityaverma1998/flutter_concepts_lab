// ============================================================
// DART VARIABLES — INTERVIEW NOTES
// Topic  : Data Types & Variable Keywords
// Author : Aditya
// ============================================================


// ──────────────────────────────────────────────────────────────
// 1. PRIMITIVE DATA TYPES
// ──────────────────────────────────────────────────────────────

// int → stores whole numbers (no decimal point)
// Range : -2^63 to 2^63-1 (on 64-bit systems)
int a = 10;

// String → stores a sequence of characters (text)
// Must be enclosed in single ('') or double ("") quotes
String str = "Aditya";

// double → stores floating-point numbers (with decimal)
// Used for precise numeric values like measurements, prices
double num = 60.5;

// bool → stores only true or false
// Used in conditions, flags, and toggle states
bool isTrue = true;


// ──────────────────────────────────────────────────────────────
// 2. SPECIAL TYPE — dynamic
// ──────────────────────────────────────────────────────────────

// dynamic → type is resolved at RUNTIME, not compile time
// Can hold ANY type and can CHANGE type later in the program
// ⚠️  No compile-time type checking — use carefully
dynamic b = 12;       // currently int
// b = "hello";       // valid! can reassign to String
// b = true;          // valid! can reassign to bool


// ──────────────────────────────────────────────────────────────
// 3. SPECIAL KEYWORDS — final & const
// ──────────────────────────────────────────────────────────────

// final → can only be SET ONCE, value assigned at RUNTIME
// Use when value is not known until the app runs
// e.g. data from an API, user input, DateTime.now()
final int myInt = 10;
// myInt = 20; // ❌ ERROR — cannot reassign a final variable

// const → COMPILE-TIME constant, value must be known BEFORE runtime
// Value is hardcoded and never changes (baked in at build time)
// Slightly more memory-efficient than final
const double PI = 3.14;
// PI = 3.14159; // ❌ ERROR — cannot reassign a const variable


// ──────────────────────────────────────────────────────────────
// 4. KEY INTERVIEW DIFFERENCES
// ──────────────────────────────────────────────────────────────

// ┌─────────────┬────────────────────────┬──────────────────────────┐
// │  Keyword    │  When value is set      │  Example use case        │
// ├─────────────┼────────────────────────┼──────────────────────────┤
// │  var        │  Compile time (inferred)│  var name = "Aditya";    │
// │  final      │  Runtime (set once)     │  final res = api.fetch() │
// │  const      │  Compile time (fixed)   │  const PI = 3.14;        │
// │  dynamic    │  Runtime (can change)   │  dynamic x = 42;         │
// └─────────────┴────────────────────────┴──────────────────────────┘

// NOTE: var vs dynamic
//   var    → type is INFERRED at compile time, cannot change type later
//   dynamic → type is checked at RUNTIME, CAN change type

// var example:
// var city = "Delhi";   // inferred as String
// city = 100;           // ❌ ERROR — type already locked as String

// dynamic example:
// dynamic city = "Delhi";
// city = 100;           // ✅ OK — dynamic allows type change


// ──────────────────────────────────────────────────────────────
// 5. QUICK MEMORY AID
// ──────────────────────────────────────────────────────────────

// int    → whole number        → int age = 25;
// String → text                → String name = "Aditya";
// double → decimal number      → double price = 99.9;
// bool   → true / false        → bool isLoggedIn = false;
// final  → assign once runtime → final token = getToken();
// const  → fixed at build time → const appName = "MyApp";
// dynamic → flexible type      → dynamic data = fetchData();


// ──────────────────────────────────────────────────────────────
// 6. WHY DART HAS NO float — INTERVIEW ANSWER
// ──────────────────────────────────────────────────────────────

// Q: Why does Dart not have a float type even though it stores decimal numbers?

// A: Dart follows the IEEE 754 standard (same as Java, Swift, JavaScript).
//    IEEE 754 defines two floating-point sizes:
//      float  → 32-bit (single precision) → 6-7  significant digits
//      double → 64-bit (double precision) → 15-16 significant digits
//
//    Dart intentionally SKIPS float and only keeps double.
//    Reasons:

// REASON 1 — Modern hardware is 64-bit
//   Today's CPUs, Android & iOS devices are all 64-bit.
//   Using 32-bit float gives NO real speed or memory benefit.
//   So two types = extra confusion for zero gain.

// REASON 2 — Dart values simplicity
//   Having both float and double forces developers to decide which to use.
//   Dart removes that decision entirely → just use double, always.

// REASON 3 — double is safer and more precise
//   double price = 99.99;  // 15-16 digits of precision ✅
//   float  price = 99.99;  // only 6-7 digits → risky for money/sensors ❌

// REASON 4 — Other languages do the same
// ┌──────────────┬──────────────────────────────────────────┐
// │  Language    │  float support                           │
// ├──────────────┼──────────────────────────────────────────┤
// │  Java/Kotlin │  has both float AND double               │
// │  Swift       │  has both Float AND Double               │
// │  JavaScript  │  only double (same as Dart)              │
// │  Python      │  only float — but internally it's double │
// │  Dart        │  only double ✅ (conscious design choice) │
// └──────────────┴──────────────────────────────────────────┘

// KEY POINT FOR INTERVIEW:
//   Dart did NOT remove float by mistake.
//   It was a deliberate design decision — keep the language simple,
//   modern, and safe. double is strictly better than float in precision
//   and performs equally well on today's hardware.

// ONE LINE ANSWER:
//   "Dart skips float because double is strictly better in precision,
//    works just as fast on 64-bit hardware, and keeping only one type
//    makes the language simpler." ✅

// ============================================================
// END OF NOTES
// ============================================================