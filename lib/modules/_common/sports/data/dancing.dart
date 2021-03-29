import '../sports_category.dart';
import '../sports.dart';
import 'requirements/sports_requirements.dart';

Sport createDancing(int id) {
  final requirements = [
    SportRequirements.skill_level,
    SportRequirements.height
  ];

  var chaCha =
      SportStyle(id: 0, name: "Cha-Cha-Cha", requirements: requirements);

  var foxtrot = SportStyle(id: 1, name: "Foxtrot", requirements: requirements);

  var quickstep =
      SportStyle(id: 2, name: "Quickstep", requirements: requirements);

  var rumba = SportStyle(id: 3, name: "Rumba", requirements: requirements);

  var tango = SportStyle(id: 4, name: "Tango", requirements: requirements);

  var twoStep = SportStyle(id: 5, name: "Two-step", requirements: requirements);

  var waltz = SportStyle(id: 6, name: "Waltz ", requirements: requirements);

  var ballRoom = SportsSubCategory(id: 0, name: "Ballroom", styles: [
    waltz,
    tango,
    foxtrot,
    quickstep,
    twoStep,
    chaCha,
    rumba,
  ]);

  var bachata = SportStyle(id: 0, name: "Bachata", requirements: requirements);
  var boleroRumba =
      SportStyle(id: 1, name: "Bolero (Rumba)", requirements: requirements);
  var kizomba = SportStyle(id: 2, name: "Kizomba", requirements: requirements);
  var mambo = SportStyle(id: 3, name: "Mambo", requirements: requirements);
  var merengue =
      SportStyle(id: 4, name: "Merengue", requirements: requirements);
  var salsa = SportStyle(id: 5, name: "Salsa", requirements: requirements);
  var samba = SportStyle(id: 6, name: "Samba", requirements: requirements);
  var zouk = SportStyle(id: 7, name: "Zouk", requirements: requirements);

  var latin = SportsSubCategory(id: 1, name: "Latin", styles: []);
  latin.styles.add(salsa);
  latin.styles.add(kizomba);
  latin.styles.add(zouk);
  latin.styles.add(mambo);
  latin.styles.add(samba);
  latin.styles.add(boleroRumba);
  latin.styles.add(merengue);
  latin.styles.add(bachata);

  var charleston =
      SportStyle(id: 0, name: "Charleston", requirements: requirements);
  var eastCoast =
      SportStyle(id: 1, name: "East Coast Swing", requirements: requirements);
  var jitterbug =
      SportStyle(id: 2, name: "Jitterbug", requirements: requirements);

  var jive = SportStyle(
      id: 3,
      name: "Jive (Swing, Boogie, Boogie-woogie)",
      requirements: requirements);

  var lindyHop =
      SportStyle(id: 4, name: "Lindy Hop", requirements: requirements);

  var rockNRoll =
      SportStyle(id: 5, name: "Rock 'n Roll", requirements: requirements);

  var westCoast =
      SportStyle(id: 6, name: "West Coast Swing", requirements: requirements);

  var swing = SportsSubCategory(id: 2, name: "Swing", styles: []);
  swing.styles.add(charleston);
  swing.styles.add(jive);
  swing.styles.add(jitterbug);
  swing.styles.add(rockNRoll);
  swing.styles.add(westCoast);
  swing.styles.add(eastCoast);
  swing.styles.add(lindyHop);

  var dancing = Sport(
      id: id,
      name: "Dancing",
      subCategory: [
        ballRoom,
        latin,
        swing,
      ],
      requirements: [],
      imagePath: "assets/sports/dancing.svg");

  return dancing;
}
