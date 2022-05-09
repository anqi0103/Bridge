import 'package:cloud_firestore/cloud_firestore.dart';

class Badges {
  String badgeName;
  String reference;
  List<String> usersEarned;

  Badges({required this.badgeName, required this.reference, required this.usersEarned});

  factory Badges.fromFirestore(DocumentSnapshot document) {
    return Badges(
      badgeName: document['badgeName'],
      reference: document['reference'],
      usersEarned: document['usersEarned']
    );
  }
}

/*
 * Badge brainstorm:  Feel free to add to this brainstorm. This story was just
 *                    creating types of badges and the asset (icons) to use.
 * 
 *                    I think we can use Font Awesome's icon library which will
 *                    fit in with our app's theme. Maybe the user can select one
 *                    badge to appear in the profile screen based off of what
 *                    they have currently earned and it will show up next to 
 *                    their username in the comment section?
 * ----------------------------------------------------------------------------
 * These are much easier and something we can start with:
 * 
 * Total comment: 25 = FaIcon(FontAwesomeIcons.gift)
 * Total comment: 50 = FaIcon(FontAwesomeIcons.award)
 * Total comment: 100 = FaIcon(FontAwesomeIcons.gem)
 * 
 * Total number of votes: 25 = FaIcon(FontAwesomeIcons.robot)
 * Total number of votes: 50 = FaIcon(FontAwesomeIcons.userAstronaut)
 * Total number of votes: 100 = FaIcon(FontAwesomeIcons.userSecret)
 * 
 * Total rating: 25 = FaIcon(FontAwesomeIcons.sun)
 * Total rating: 50 = FaIcon(FontAwesomeIcons.star);
 * Total rating: 100 = FaIcon(FontAwesomeIcons.rocket);
 * 
 * Assigned yourself an attribute: FaIcon(FontAwesomeIcons.fire)
 * 
 * First commenter on a prompt: FaIcon(FontAwesomeIcons.dove);
 * 
 * ----------------------------------------------------------------------------
 * These are harder and idk if worth the effort since you would have to create
 * extra tracking / make changes to currently existing models. I was thinking 
 * we could probably add these later if we have time. 
 * 
 * Comment on all 5 prompts in one day
 * 
 * Login 7 days in a row
 * Comment at least once daily for 7 days in a row
 * Upvote at least one comment daily for 7 days in a row
 * 
 * Total days logged in/used app: 7
 * Total days logged in/used app: 14
 * Total days logged in/used app: 28
 * 
 */