
--Personen:
INSERT INTO Person VALUES (7609010257, "Hans", "Krob", "Wien", "Taborstraße 33/17");
INSERT INTO Person VALUES (5614031288, "Karl", "Huber", "Wien", "Margaretenstraße 120/13");
INSERT INTO Person VALUES (1491051956, "Maria", "Heilinger", "Wien", "Mühlgasse 30/11/2");
INSERT INTO Person VALUES (6542151288, "Anna", "Stör", "Korneuburg", "Hauptstraße 1/1");
INSERT INTO Person VALUES (3356081467, "Klaus", "Frodl", "Gänserndorf", "Postgasse 3/14");
INSERT INTO Person VALUES (8799280189, "Peter", "Lois", "Wien", "Sensengasse 9/4/13");
INSERT INTO Person VALUES (2818092772, "Annemarie", "Mayr", "Wien", "Praterstraße 30/12");
INSERT INTO Person VALUES (4173040476, "Gertrude", "Stoika", "Graz", "Schillerstraße 12/8");
INSERT INTO Person VALUES (8154051566, "Waltraud", "Klingl", "Salzburg", "Schwarzstraße 28/24");
INSERT INTO Person VALUES (5885050573, "Emilia", "Stoiber", "Salzburg", "Franz-Josef-Straße 40/3");
INSERT INTO Person VALUES (7761031800, "Hannelore", "Kerbl", "Wien", "Schönbrunner Straße 40/2/49");
INSERT INTO Person VALUES (9099260751, "Dominik", "Seilinger", "Wien", "Hollandstraße 8/2");
INSERT INTO Person VALUES (2290141191, "Blasius", "Fuchs", "Wien", "Anton-Leebgasse 3/4/38");
INSERT INTO Person VALUES (6542130988, "Mirko", "Hörhan", "Salzburg", "Residenzplatz 1/20");
INSERT INTO Person VALUES (3131041190, "Stanislaus", "Schmalhorst", "Bockfließ", "Mozartstraße 12");
INSERT INTO Person VALUES (2875160960, "Margot", "Komolka", "Wien", "Lindengasse 40/6");
INSERT INTO Person VALUES (3148300700, "Sandra", "Dobes", "Wien", "Kandlgasse 93/3/9");
INSERT INTO Person VALUES (1721220694, "Elisabeth", "Bergner", "Wien", "Buchengasse 14/5");
INSERT INTO Person VALUES (5348011282, "Gerlinde", "Ebenhorst", "Salzburg", "Brunnhausgasse 2/17");
INSERT INTO Person VALUES (1103180483, "Hannes", "Maurer", "Salzburg", "Pfadfinderweg 18");
SELECT * FROM Person;

INSERT INTO Telefonnummer VALUES (7609010257, 06608027854);
INSERT INTO Telefonnummer VALUES (5614031288, 06602782847);
INSERT INTO Telefonnummer VALUES (1491051956, 06648454842);
INSERT INTO Telefonnummer VALUES (6542151288, 06508812482);
INSERT INTO Telefonnummer VALUES (3356081467, 06993202090);
INSERT INTO Telefonnummer VALUES (8799280189, 06607320624);
INSERT INTO Telefonnummer VALUES (2818092772, 06646350845);
INSERT INTO Telefonnummer VALUES (4173040476, 06643161723);
INSERT INTO Telefonnummer VALUES (8154051566, 06501446196);
INSERT INTO Telefonnummer VALUES (5885050573, 06605467457);
INSERT INTO Telefonnummer VALUES (7761031800, 06508611145);
INSERT INTO Telefonnummer VALUES (9099260751, 06505936197);
INSERT INTO Telefonnummer VALUES (2290141191, 06993617237);
INSERT INTO Telefonnummer VALUES (6542130988, 06997665120);
INSERT INTO Telefonnummer VALUES (3131041190, 06607329009);
INSERT INTO Telefonnummer VALUES (2875160960, 06608044770);
INSERT INTO Telefonnummer VALUES (3148300700, 06644968073);
INSERT INTO Telefonnummer VALUES (1721220694, 06501034283);
INSERT INTO Telefonnummer VALUES (5348011282, 06607388203);
INSERT INTO Telefonnummer VALUES (1103180483, 06644975542);

SELECT * FROM Telefonnummer;

INSERT INTO Besucher VALUES (7609010257, 3274584619);
INSERT INTO Besucher VALUES (5614031288, 6656012472);
INSERT INTO Besucher VALUES (1491051956, 2615000148);
INSERT INTO Besucher VALUES (6542151288, 9775607100);
INSERT INTO Besucher VALUES (3356081467, 8314861895);
INSERT INTO Besucher VALUES (3148300700, 1356478930);
INSERT INTO Besucher VALUES (1721220694, 3098564661);
SELECT * FROM Besucher;

INSERT INTO Requisiteur VALUES (7761031800);
INSERT INTO Requisiteur VALUES (9099260751);
INSERT INTO Requisiteur VALUES (2290141191);
INSERT INTO Requisiteur VALUES (6542130988);
INSERT INTO Requisiteur VALUES (3131041190);
INSERT INTO Requisiteur VALUES (2875160960);
SELECT * FROM  Requisiteur;
-- Sänger Datum fehlt noch!!!
INSERT INTO Sänger VALUES (8799280189, "Peter der Große", "2019-01-13");
INSERT INTO Sänger VALUES (2818092772, "Silvia Eis", "2019-01-13");
INSERT INTO Sänger VALUES (4173040476, "Traude Weiß", "2019-01-13");
INSERT INTO Sänger VALUES (8154051566, "Ann Heat", "2019-01-13");
INSERT INTO Sänger VALUES (5885050573, "Marie Luise Steil", "2019-01-13");
INSERT INTO Sänger VALUES (5348011282, "Gerlinde Storm", "2019-01-13");
INSERT INTO Sänger VALUES (1103180483, "Luigi Gustini", "2019-01-13");
SELECT * FROM Sänger;

INSERT INTO Bank VALUES (32000, "Raiffeisen Landesbank"); 
INSERT INTO Bank VALUES (12000, "Bank Austria");
INSERT INTO Bank VALUES (19250, "Hello Bank"); 
INSERT INTO Bank VALUES (14900, "BAWAG"); 
-- 13 Angestellte (Sänger & Requisiteur)
INSERT INTO Angestellte_hat_Gehaltskonto VALUES (7761031800, 69294, 416979950, 1862, 32000);
INSERT INTO Angestellte_hat_Gehaltskonto VALUES (9099260751, 65031, 215397715, 52, 12000);
INSERT INTO Angestellte_hat_Gehaltskonto VALUES (2290141191, 82045, 292263075, 1018, 14900);
INSERT INTO Angestellte_hat_Gehaltskonto VALUES (6542130988, 22954, 174584179, 3791, 32000);
INSERT INTO Angestellte_hat_Gehaltskonto VALUES (3131041190, 35826, 559137918, 2126, 32000);
INSERT INTO Angestellte_hat_Gehaltskonto VALUES (2875160960, 46415, 618423010, 374, 12000);
INSERT INTO Angestellte_hat_Gehaltskonto VALUES (8799280189, 64069, 548845429, 4363, 19250);
INSERT INTO Angestellte_hat_Gehaltskonto VALUES (2818092772, 92968, 965349389, 871, 14900);
INSERT INTO Angestellte_hat_Gehaltskonto VALUES (4173040476, 68908, 599134866, 3577, 14900);
INSERT INTO Angestellte_hat_Gehaltskonto VALUES (8154051566, 48644, 512053883, 3677, 19250);
INSERT INTO Angestellte_hat_Gehaltskonto VALUES (5885050573, 16327, 253788704, 462, 32000);
INSERT INTO Angestellte_hat_Gehaltskonto VALUES (5348011282, 78083, 108087565, 635, 19250);
INSERT INTO Angestellte_hat_Gehaltskonto VALUES (1103180483, 64817, 281116953, 3519, 12000);
SELECT * FROM Angestellte_hat_Gehaltskonto;

INSERT INTO Sprache VALUES ("Italienisch"); 
INSERT INTO Sprache VALUES ("Deutsch"); 
INSERT INTO Sprache VALUES ("Russisch"); 
INSERT INTO Sprache VALUES ("Französisch"); 
SELECT * FROM Sprache;

INSERT INTO Besucher_bevorzugen VALUES (2818092772, 2615000148); 
INSERT INTO Besucher_bevorzugen VALUES (2818092772, 3098564661);
INSERT INTO Besucher_bevorzugen VALUES (1103180483, 1356478930);
INSERT INTO Besucher_bevorzugen VALUES (4173040476, 6656012472);
INSERT INTO Besucher_bevorzugen VALUES (5348011282, 9775607100);
INSERT INTO Besucher_bevorzugen VALUES (5348011282, 3274584619);
SELECT * FROM Besucher_bevorzugen;

-- muss immer doppelt eingetragen werden oder nicht? 
INSERT INTO vertragen_sich_nicht VALUES (8799280189, 5348011282);
INSERT INTO vertragen_sich_nicht VALUES (5348011282, 8799280189);
INSERT INTO vertragen_sich_nicht VALUES (4173040476, 8799280189);
INSERT INTO vertragen_sich_nicht VALUES (8799280189, 4173040476);
SELECT * FROM vertragen_sich_nicht;

-- komisch warum Soznr??? 
INSERT INTO Rollenbücher_haben VALUES (5314, 7761031800, "Zauberflöte", "Mozart");
INSERT INTO Rollenbücher_haben VALUES (3903, 1103180483, "Carmen", "Bizet");
INSERT INTO Rollenbücher_haben VALUES (8244, 8154051566, "La Traviata", "Verdi");
INSERT INTO Rollenbücher_haben VALUES (2865, 2875160960, "Aida", "Verdi");
INSERT INTO Rollenbücher_haben VALUES (6947, 5348011282, "Pique Dame", "Peter Tschaikowski");
INSERT INTO Rollenbücher_haben VALUES (9666, 9099260751, "La Bohème", "Puccini");
INSERT INTO Rollenbücher_haben VALUES (1898, 2290141191, "Tosca", "Puccini");
SELECT * FROM Rollenbücher_haben;

INSERT INTO Rollenbücher_entlehnen VALUES (7761031800, 5314); 
INSERT INTO Rollenbücher_entlehnen VALUES (9099260751, 3903); 
INSERT INTO Rollenbücher_entlehnen VALUES (2290141191, 8244); 
INSERT INTO Rollenbücher_entlehnen VALUES (6542130988, 2865); 
INSERT INTO Rollenbücher_entlehnen VALUES (3131041190, 9666); 
INSERT INTO Rollenbücher_entlehnen VALUES (2875160960, 1898); 
SELECT * FROM Rollenbücher_entlehnen;


INSERT INTO Oper_gehört_Rollenbuchtypen VALUES ("Zauberflöte", 40, 4, 5314, "Mozart"); 
INSERT INTO Oper_gehört_Rollenbuchtypen VALUES ("Carmen", 20, 3, 3903, "Bizet"); 
INSERT INTO Oper_gehört_Rollenbuchtypen VALUES ("La Traviata", 35, 4, 8244, "Verdi"); 
INSERT INTO Oper_gehört_Rollenbuchtypen VALUES ("Aida", 48, 6, 2865, "Verdi"); 
INSERT INTO Oper_gehört_Rollenbuchtypen VALUES ("Pique Dame", 38, 4, 6947, "Peter Tschaikowski"); 
INSERT INTO Oper_gehört_Rollenbuchtypen VALUES ("La Bohème", 50, 6, 9666, "Puccini"); 
INSERT INTO Oper_gehört_Rollenbuchtypen VALUES ("Tosca", 46, 4, 1898, "Puccini"); 
SELECT * FROM Oper_gehört_Rollenbuchtypen;

-- Datum und Uhrzeit könnten problematisch sein? ohne "" kommt ein falsches Datum
-- keine selbe Uhrzeit oder selbes Datum möglich muss gelöst werden!!!
INSERT INTO Aufführung_von VALUES ("2019-01-13", "19:00", "Simon Rattle", 15000, "Zauberflöte"); 
INSERT INTO Aufführung_von VALUES ("2019-02-10", "20:00", "Simon Rattle", 15000, "Zauberflöte"); 
INSERT INTO Aufführung_von VALUES ("2019-02-11", "21:00", "Simon Rattle", 15000, "Zauberflöte"); 
INSERT INTO Aufführung_von VALUES ("2019-03-28", "12:30", "Simon Rattle", 15000, "Zauberflöte"); 
INSERT INTO Aufführung_von VALUES ("2018-11-12", "19:30", "Christoph von Dohnányi", 20000, "Aida"); 
INSERT INTO Aufführung_von VALUES ("2020-12-26", "18:30", "Arnold Östman", 25000, "La Bohème"); 
INSERT INTO Aufführung_von VALUES ("2019-12-26", "18:30", "Arnold Östman", 25000, "La Bohème"); 
INSERT INTO Aufführung_von VALUES ("2019-12-01", "19:30", "Arnold Östman", 25000, "La Bohème"); 
INSERT INTO Aufführung_von VALUES ("2019-12-26", "20:30", "Arnold Östman", 25000, "La Bohème"); 
INSERT INTO Aufführung_von VALUES ("2019-12-26", "21:30", "Arnold Östman", 25000, "La Bohème"); 
INSERT INTO Aufführung_von VALUES ("2020-03-21", "19:00", "Christoph von Dohnányi", 20000, "Aida"); 
INSERT INTO Aufführung_von VALUES ("2020-04-26", "21:00", "Christoph von Dohnányi", 20000, "Aida"); 
INSERT INTO Aufführung_von VALUES ("2010-12-26", "19:00", "Christoph von Dohnányi", 20000, "Aida"); 
INSERT INTO Aufführung_von VALUES ("2021-06-26", "19:00", "Christoph von Dohnányi", 20000, "Aida"); 
INSERT INTO Aufführung_von VALUES ("2020-01-26", "19:00", "Christoph von Dohnányi", 20000, "Aida"); 
INSERT INTO Aufführung_von VALUES ("2019-03-02", "19:00", "Marco Armiliato", 30000, "Tosca"); 
INSERT INTO Aufführung_von VALUES ("2019-04-10", "19:00", "Marco Armiliato", 30000, "Tosca"); 
INSERT INTO Aufführung_von VALUES ("2019-06-12", "19:00", "Marco Armiliato", 30000, "Tosca"); 
INSERT INTO Aufführung_von VALUES ("2019-07-22", "18:30", "Marco Armiliato", 30000, "Tosca"); 
INSERT INTO Aufführung_von VALUES ("2019-09-20", "19:00", "Marco Armiliato", 30000, "Tosca"); 
INSERT INTO Aufführung_von VALUES ("2019-06-21", "17:00", "Mariss Jansons", 22000, "Pique Dame"); 
INSERT INTO Aufführung_von VALUES ("2019-08-24", "18:30", "Mariss Jansons", 22000, "Pique Dame"); 
INSERT INTO Aufführung_von VALUES ("2019-10-12", "19:00", "Mariss Jansons", 22000, "Pique Dame"); 
INSERT INTO Aufführung_von VALUES ("2019-12-18", "19:30", "Mariss Jansons", 22000, "Pique Dame"); 
INSERT INTO Aufführung_von VALUES ("2019-12-20", "19:00", "Mariss Jansons", 22000, "Pique Dame"); 
INSERT INTO Aufführung_von VALUES ("2020-01-13", "19:30", "Mariss Jansons", 22000, "Pique Dame"); 
INSERT INTO Aufführung_von VALUES ("2020-02-14", "17:30", "Jean-Christophe Spinosi", 18000, "Carmen"); 
INSERT INTO Aufführung_von VALUES ("2020-03-01", "19:00", "Jean-Christophe Spinosi", 18000, "Carmen"); 
INSERT INTO Aufführung_von VALUES ("2020-04-25", "18:30", "Jean-Christophe Spinosi", 18000, "Carmen"); 
INSERT INTO Aufführung_von VALUES ("2020-06-17", "18:30", "Jean-Christophe Spinosi", 18000, "Carmen"); 
INSERT INTO Aufführung_von VALUES ("2020-08-10", "19:30", "Jean-Christophe Spinosi", 18000, "Carmen"); 
SELECT * FROM Aufführung_von;

INSERT INTO reservieren VALUES (7609010257, 49438, "2019-02-11", "21:00", "A123"); 
INSERT INTO reservieren VALUES (5614031288, 80092, "2019-03-28", "12:30", "C532"); 
SELECT * FROM reservieren;

INSERT INTO singen VALUES (8799280189, "2019-01-13", "19:00");
INSERT INTO singen VALUES (2818092772, "2019-01-13", "19:00");
INSERT INTO singen VALUES (4173040476, "2019-03-28", "12:30");
INSERT INTO singen VALUES (8154051566, "2019-03-28", "12:30");
INSERT INTO singen VALUES (5885050573, "2018-12-26", "18:30");
INSERT INTO singen VALUES (5348011282, "2018-12-26", "18:30");
INSERT INTO singen VALUES (1103180483, "2019-03-28", "12:30");
SELECT * FROM singen;

INSERT INTO kann VALUES (8799280189, "Zauberflöte", "Deutsch");
INSERT INTO kann VALUES (2818092772, "La Bohème", "Italienisch");
INSERT INTO kann VALUES (4173040476, "Pique Dame", "Russisch");
INSERT INTO kann VALUES (8154051566, "Zauberflöte", "Deutsch");
INSERT INTO kann VALUES (5885050573, "Tosca", "Italienisch");
INSERT INTO kann VALUES (5348011282, "Carmen", "Italienisch");
INSERT INTO kann VALUES (1103180483, "La Bohème", "Italienisch");
SELECT * FROM kann;
