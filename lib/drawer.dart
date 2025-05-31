import 'package:flutter/material.dart';
import 'assistant_virtual.dart'; // Import de la page Assistant Virtual

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    // Define the green color palette used in the main app for consistency
    const Color primaryGreen = Color(0xFF4CAF50); // A standard green
    const Color secondaryGreen = Color(0xFF81C784); // A lighter green

    return Drawer(
      child: Column(
        children: [
          // Updated DrawerHeader with new name and potentially slightly adjusted gradient
          DrawerHeader(
            decoration: BoxDecoration(
              // Using a gradient that fits the app's new green theme
              gradient: LinearGradient(
                colors: [
                  primaryGreen, // Use the primary green
                  secondaryGreen, // Use the secondary green
                ],
                begin: Alignment.topLeft, // Optional: adjust gradient direction
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center, // Center vertically in the row
              children: [
                // CircleAvatar (keeping the image asset and size)
                CircleAvatar(
                  backgroundImage: AssetImage('assets/img.jpg'), // Make sure this path is correct
                  radius: 30,
                ),
                const SizedBox(width: 10), // Add spacing between avatar and text
                // Updated Text with the new name
                Expanded( // Use Expanded to prevent text overflow if the name is long
                  child: Text(
                    "Abdelfatah mennoun!", // Changed the name
                    style: const TextStyle(
                      color: Colors.white, // White text for visibility on gradient
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis, // Handle potential overflow
                  ),
                ),
              ],
            ),
          ), // DrawerHeader

          // ListTiles with replaced icons and original text/functionality

          // Assistant virtual
          ListTile(
            leading: Icon(Icons.chat_bubble_outline), // Replaced icon (e.g., chat bubble)
            title: Text('Assistant virtual'),
            onTap: () {
              Navigator.pop(context); // Ferme le drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AssistantVirtual(),
                ),
              );
            },
          ),

          // Traitement des objets (first one)
          ListTile(
            leading: Icon(Icons.tune), // Replaced icon (e.g., tuning/processing)
            title: Text('Traitement des objets'),
            onTap: () {
              Navigator.pop(context); // Ferme le drawer
              // Vous pouvez ajouter la navigation vers une autre page ici
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Traitement des objets - À implémenter')),
              );
            },
          ),

          // Traitement des objets (second one)
          ListTile(
            leading: Icon(Icons.filter_center_focus), // Replaced icon (e.g., focus/scanning)
            title: Text('Traitement des objets'),
            onTap: () {
              Navigator.pop(context); // Ferme le drawer
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Traitement des objets 2 - À implémenter')),
              );
            },
          ),

          // Compte
          ListTile(
            leading: Icon(Icons.person_outline), // Replaced icon (e.g., person outline)
            title: Text('Compte'),
            onTap: () {
              Navigator.pop(context); // Ferme le drawer
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Page Compte - À implémenter')),
              );
            },
          ),

          // ExpansionTile with replaced icon and children icons
          ExpansionTile(
            leading: Icon(Icons.build_circle_outlined), // Replaced icon (e.g., build/test)
            title: Text('Test'),
            children: [
              // Assistant virtual (inside ExpansionTile)
              ListTile(
                leading: Icon(Icons.mic_none), // Replaced icon (e.g., microphone)
                title: Text('Assistant virtual'),
                onTap: () {
                  Navigator.pop(context); // Ferme le drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AssistantVirtual(),
                    ),
                  );
                },
              ),
              // Traitement des objets (inside ExpansionTile)
              ListTile(
                leading: Icon(Icons.construction_outlined), // Replaced icon (e.g., construction/tools)
                title: Text('Traitement des objets'),
                onTap: () {
                  Navigator.pop(context); // Ferme le drawer
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Test - Traitement des objets - À implémenter')),
                  );
                },
              ),
              // Contacts (inside ExpansionTile)
              ListTile(
                leading: Icon(Icons.people_outline), // Replaced icon (e.g., people outline)
                title: Text('Contacts'),
                onTap: () {
                  Navigator.pop(context); // Ferme le drawer
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Contacts - À implémenter')),
                  );
                },
              ),
            ]
          ),
          // You can add more items here
          
          // Optional: Add a Spacer to push remaining items to the bottom
          // const Spacer(),
          
          // Optional: Add a Logout button at the bottom
          // ListTile(
          //   leading: Icon(Icons.logout, color: Colors.redAccent),
          //   title: Text('Déconnexion'),
          //   onTap: () {
          //     // Implement logout logic
          //     Navigator.pop(context); // Close drawer
          //     // Navigate to login/auth screen
          //   },
          // ),
          // const SizedBox(height: 20), // Space at the bottom
        ],
      ), // Column
    ); // Drawer
  }
}