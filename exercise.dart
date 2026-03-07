class User {
  final String name;
  final String? email;
  
  User(this.name, this.email);
  
  @override
  String toString() => 'User(name: $name, email: $email)';
}

void main() {
  // Create list with the specified users
  final users = [
    User('Alex', 'alex@example.com'),
    User('Blake', null),
    User('Casey', 'casey@work.com'),
  ];
  
  print('=== User Email Processing ===\n');
  
  // 1. Print email addresses in uppercase for users who have them
  print('Email addresses (uppercase):');
  for (final user in users) {
    final email = user.email?.toUpperCase();
    if (email != null) {
      print(email);
    }
  }
  
  print('\n---\n');
  
  // 2. For users without an email, print "[Name] has no email."
  print('Users without email:');
  for (final user in users) {
    if (user.email == null) {
      print('${user.name} has no email.');
    }
  }
  
  print('\n---\n');
  
  // 3. Count how many users have valid (non-null) emails
  final emailCount = users.where((user) => user.email != null).length;
  print('Total users with valid emails: $emailCount');
  
  // Alternative demonstration using null-safe operations
  print('\n=== Alternative Null-Safe Operations ===\n');
  
  // Using Elvis operator and safe calls
  print('Combined processing:');
  for (final user in users) {
    final emailDisplay = user.email?.toUpperCase() ?? 'NO EMAIL';
    print('${user.name}: $emailDisplay');
  }
  
  // Using fold to count emails
  final emailCountFold = users.fold(0, (count, user) => 
      user.email != null ? count + 1 : count);
  print('\nEmail count (using fold): $emailCountFold');
  
  // Using map to transform users
  final userEmails = users
      .map((user) => user.email?.toUpperCase())
      .where((email) => email != null)
      .toList();
  print('\nValid emails list: $userEmails');
}
