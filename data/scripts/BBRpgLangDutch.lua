--
-- This object holds written text, to easy translation of the game.
--

import("Lang.lua")

BBRpgLangDutch = Lang:subclass
{
	name = "BBRpgLangDutch";

	vars = {
		PLAY = "Spelen",
		QUICKPLAY = "Direct Spelen",
		CREDITS = "Makers",
		LANGUAGE = "Taal",
		QUIT = "Afsluiten",
		CONTINUE = "Doorgaan",
	};

	convs = {
		-- Conversations. Used in sequences.
		Intro1 = {
			{"Mr. Prosser", "Gevangene 3 van de 5. Goed gedrag. Hier zijn je bezittingen: Een Timex digitaal horloge, kapot. Een ongebruikt condoom, en een gebruikte. <pause> Een zonnebril. Drieentwintig euro en zeven cent. Wilt u hier even tekenen?"},
		},
		Intro2 = {
			{"Guard", "Deze kant op."},
		},
		Intro3 = {
			{"Elwood", "Bedankt voor jullie gastvrijheid."},
			{"Guard", "Geen dank. Ik hoop voor je dat ik je hier niet meer terug zie."},
			{"Elwood", "Wie weet..."},
		},
		Intro4 = {
			{"Jake", "Elwood, hier sta ik!"},
		},
		Intro5 = {
			{"Elwood", "Jake, ik snap hier niets van!"},
			{"Jake", "Waar heb je het over?"},
			{"Elwood", "Dit! Net alsof ik dit al een keer eerder meegemaakt heb!"},
			{"Jake", "Je hebt gewoon een deja-vu."},
			{"Elwood", "Nee, het is alsof..."},
			{"Jake", "Kun je niet gewoon je bek houden en in de auto stappen?!"},
			{"Elwood", "Okee, maar wat is dit?"},
			{"Jake", "Wat?"},
			{"Elwood", "Deze auto. Deze kutauto. Waar is de Caddy?"},
			{"Jake", "De wat?"},
			{"Elwood", "De Cadillac die we vroeger hadden. Ons Blues Mobiel!"},
			{"Jake", "Oh, die heb ik geruild."},
			{"Elwood", "Voor een microfoon?"},
			{"Jake", "Precies, maar hoe wist je..."},
			{"Elwood", "Een wilde gok."},
			{"Jake", "... Laten we in de auto stappen."},
		},
		Intro5a = {
			{"Jake","Hier, neem deze walkie talkie. Die zullen we nodig hebben.."},
		},
		Intro6 = {
			{"Elwood", "Niet te geloven, deze zijn nog groter dan de GSM's die ze in de X-files gebruiken..."},
			{"Jake", "Luister, we hebben belangrijke dingen te doen."},
			{"Elwood", "Ja! Weer een band beginnen!"},
			{"Jake", "Nee, dat deden we de laatste keer weet je nog?"},
			{"Elwood", "Waar heb je het over?"},
			{"Jake", "Ach, laat maar zitten."},
			{"Elwood", "Maar..."},
			{"Jake", "Luister eikel: we moeten Brian redden."},
			{"Elwood", "Wie?"},
			{"Jake", "Onze broer, Brian!"},
			{"Elwood", "Ik weet niks van een derde broer! Al helemaal geen Brian!"},
			{"Jake", "Hij is geadopteerd, nou je bek houden en me uit laten spreken!"},
			{"Elwood", "Ik begrijp niet dat onze ouders dat ons nooit verteld hebben..."},
			{"Jake", "Het jou nooit verteld hebben..."},
			{"Elwood", "Wat?"},
			{"Jake", "Ze hebben het JOU nooit verteld."},
			{"Elwood", "Je bedoelt dat jij het altijd al geweten hebt?"},
			{"Jake", "Ja, maar laat je me nou eindelijk een keer uitspreken?!"},
			{"Jake", "Goed, onze broer Brian, ook wel bekend als The Brain, is twee weken geleden gearresteerd terwijl hij met een gestolen creditcard mini-raket motoren in een hobbywinkel kocht voor zijn mini versie van de Columbia Ruimteveer met schaal een op honderd, gemaakt van alleen maar mini-raket motoren, ducktape, gebruikte walkmans, oude houten ijsstokjes, fietsen en een autoband."},
			{"Elwood", "Een op 100? That is nog behoorlijk groot."},
			{"Jake", "Ja, ik weet het. Maar goed, we moeten hem bevrijden! De wereldvrede staat hier op het spel!"},
			{"Elwood", "Ik vrees dat ik het belang hiervan nog niet zo in de gaten heb..."},
			{"Jake", "Kijk, Brian, alias The Brain, is lid van de Internationale Schaak Club. Een vriend van hem, ook lid van deze Schaak Club, wil met deze miniversie van de Columbia ruimteveer een miniatuur aanvalssateliet lanceren om de Chinese aanvalssateliet die gericht is op Washington aan te vallen, en op deze manier de Vierde Werelde Oorlog voorkomen."},
			{"Elwood", "Derde. De Derde Wereld Oorlog. Er zijn er maar twee geweest Jake."},
			{"Jake", "O ja? En hoe zit het dan met al die kroegengevechten die we hebben mee gemaakt? Alleen maar buitenlanders daar."},
			{"Elwood", "Dat is waar..."},
			{"Jake", "Dus, als we niet onze grote broer redden betekent dat het einde!"},
			{"Elwood", "GROTE broer? Nu vertel je me dat hij ouders is dan ons, hetgeen betekent dat hij nog voor onze geboorte geadopteerd is."},
			{"Jake", "Ja."},
		},
		Intro7 = {
			{"Jake", "Nou daar zijn we dan!"},
			{"Elwood", "Waar zijn we?"},
			{"Jake", "In mijn wijk! Mijn apartement is daar!"},
			{"Elwood", "Okee, aan de slag dan maar."},
		},
		WhereKeys = {
			{"Jake", "Elwood, heb ik mijn sleutels aan jou gegeven?"},
			{"Elwood", "Deed je dat niet?"},
			{"Jake", "Deed ik dat?"},
			{"Elwood", "Nee."},
			{"Jake", "Die moeten we eerst vinden. Mijn koevoet ligt in mijn huis. Die zullen we nodig hebben."},
		},
		AtJakesPlace = {
			{"Jake", "Welkom in Case-del-Jake!"},
			{"Elwood", "Man, het stinkt hier..."},
			{"Elwood", "Letterlijk."},
			{"Jake", "Echt waar? Nooit opgemerkt."},
		},
		AtJakesPlace2 = {
			{"Elwood", "Wat een zootje hier."},
			{"Jake", "It's better than the hellhole you lived in the past couple of years."},
		},
		FindKeyFob = {
			{"{PLAYER}", "Daar ligt ie! Ik zie de sleutelbos!"},
			{"Jake", "We hebben mijn gelukssleutelbos!"},
			{"Elwood", "Dus je probeert me duidelijk te maken dat dit allemaal was om jouw tentakelsleutelbos te vinden?"},
			{"Jake", "Ja! Hij is speciaal voor mij! Hij brengt me geluk!"},
			{"Elwood", "Noem je dit geluk?"},
			{"Jake", "Hou je kop."},
		},
		FindBrian1Jake = {
			{"Jake", "Brian!"},
			{"Brian", "Jake!"},
			{"Jake", "Hier, pak deze walkie talkie om met ons te kunnen praten."},
		},
		FindBrian2Jake = {
			{"Brian", "Ons?"},
			{"Elwood", "Brian!"},
			{"Brian", "Wie ben jij?"},
			{"Elwood", "Ik ben je andere broer!"},
			{"Brian", "Ik heb een andere broer?"},
			{"Jake", "Ja, hij is geadopteerd."},
			{"Elwood", "Wat?"},
			{"Brian", "Ik kan maar niet begrijpen dat onze ouders het ons nooit verteld hebben."},
			{"Jake", "Het jou nooit verteld hebben."},
			{"Brian", "Wat?"},
			{"Jake", "Ik kan maar niet begrijpen dat onze ouders het JOU nooit verteld hebben <zucht>."},
			{"Brian", "Je wist het?"},
			{"Brian", "Maar aan de andere kant, ik kan ook niet begrijpen dat onze ouders hem nooit verteld hebben dat hij geadopteerd is."},
			{"Elwood", "Jij bent degene die geadopteerd is, ik ben een echte Blues Brother!"},
			{"Jake", "Zouden jullie allebei je kop kunnen houden? Laten we hier wegwezen."},
		},
		FindBrian1Elwood = {
			{"Elwood", "Brian!"},
			{"Brian", "Wie ben jij? Je lijkt net een kleine vette kopie van Jake."},
			{"Elwood", "Ik ben je andere broer!"},
			{"Brian", "Ik heb een andere broer?"},
			{"Elwood", "Als je het niet geloofd dan kun je het aan Jake vragen met deze walkie talkie."},
		},
		FindBrian2Elwood = {
			{"Jake", "Brian!"},
			{"Brian", "Heb ik een andere broer?"},
			{"Jake", "Ja, hij is geadopteerd."},
			{"Elwood", "Wat?"},
			{"Brian", "Ik kan maar niet begrijpen dat onze ouders het ons nooit verteld hebben."},
			{"Jake", "Het jou nooit verteld hebben."},
			{"Brian", "Wat?"},
			{"Jake", "Ik kan maar niet begrijpen dat onze ouders het JOU nooit verteld hebben <zucht>."},
			{"Brian", "Je wist het?"},
			{"Brian", "Maar aan de andere kant, ik kan ook niet begrijpen dat onze ouders hem nooit verteld hebben dat hij geadopteerd is."},
			{"Elwood", "Jij bent degene die geadopteerd is, ik ben een echte Blues Brother!"},
			{"Jake", "Zouden jullie allebei je kop kunnen houden? Laten we hier wegwezen."},
		},
		EscapedInAppartment = {
			{"Brian", "Ongelofelijk, wat een rotzooi hier!"},
			{"Elwood", "Dat heb ik hem ook al verteld. Hij noemt dit 'geluk'."},
			{"Brian", "Misschien is hij degene die geadopteerd is."},
			{"Jake", "Wat?"},
			{"Elwood", "Niets."},
			{"Brian", "Okee, terzake. We moeten het uitbreken van de Vierde Wereld Oorlog voorkomen."},
			{"Elwood", "Maar hoe?"},
			{"Brian", "Alles wat ik nodig heb zijn mijn mini-raket motoren, zodat ik ze aan Lee kan geven."},
			{"Jake", "Wie is Lee?"},
			{"Brian", "Hij is degene die de mini-raket gaat lanceren."},
			{"Elwood", "Ach natuurlijk, Lee!"},
			{"Jake", "Aha, en waar zijn de mini-raket motoren?"},
			{"Brian", "Ehm, ja, dat is misschien een probleempje. Die heb ik verstop in een bult rotzooi vlak voordat ik opgepakt werd door de politie..."},
			{"Elwood", "Nou dat is weer geweldig. En hoe gaan we die dan terug vinden?"},
			{"Brian", "Ik denk dat we maar eens moeten gaan zoeken."}
		},
		FindMiniRocketEngines = {
			{"{PLAYER}", "Ik heb ze gevonden. De mini-raket motoren liggen hier."},
			{"Brian", "Okee, dat is geweldig. Laten we naar Lee gaan en ze aan hem geven. Hij leeft in het zuidwestestelijke gedeelte aan de 'Planetenlaan 192'."},
			{"Jake", "Okee."},
			{"Elwood", "Tot daar."},
		},
		Ending1 = {
			{"Brian", "Lee!"},
			{"Lee", "Hallo daar."},
			{"Elwood", "Dit is Lee?"},
			{"Jake", "Aangezien Brian de man kent, en dat Brian hem Lee noemt zit het er dik in dat het Lee is."},
			{"Lee", "Inderdaad, ik ben degene die Lee genoemd wordt."},
			{"Brian", "We hebben de mini-raket motoren voor de miniversie van de Columbia ruimteveer die een miniaanval gaat uitvoeren en daarmee de Vierde Wereld Oorlog gaat voorkomen! Alstjeblieft!"},
		},
		Ending2 = {
			{"Lee", "Okee, fantastisch! Trouwens, het is de Vijfde Wereld Oorlog."},
			{"Elwood", "Oh nee, niet weer..."},
			{"Jake", "Vijfde? Kroegengevechten?"},
			{"Lee", "Inderdaad."},
			{"Elwood", "Nou?"},
			{"Jake", "Nou wat?"},
			{"Elwood", "Moet Lee niet aan het werk, terwijl wij naar huis gaan, vergeten dat deze akelige missie ooit gebeurd is, en muziek maken?"},
			{"Jake", "Goed idee."},
			{"Elw00t", "Waarom beginnen we niet met zijn drieen een band?"},
		},		
		WallAndTubeElwood = {
			{"{PLAYER}", "Ik pas niet in deze buis. Hij is veel te smal!"},
		},
		WallAndTube1 = {
			{"{PLAYER}", "Ik kruip naar de andere kant van de buis."},
		},
		WallAndTube2 = {
			{"{PLAYER}", "Gelukkig, een uitgang."},
		},
		TooDangerous = {
			{"{PLAYER}", "Ik kan maar beter bij die lui uit de buurt blijven..."},
		},
		RemovePutdeksel = {
			{"{PLAYER}", "Ah ja, hij beweegt... Gelukkig hebben we de kaarten van het riool uit ons hoofd geleerd."},
		},
		CantRemovePutdeksel = {
			{"{PLAYER}", "Ik krijg hem niet in beweging. Ik denk dat ik een stuk gereedschap nodig heb om hem te bewegen."},
		},
		Crowbar = {
			{"{PLAYER}", "Daar is een koevoet."},
			{"Jake", "Dat is geweldig. Die zullen we nodig hebben om het riool in te komen."},
			{"Elwood", "Wat? Het riool?!"},
			{"Jake", "Ja, wat anders? Klop jij liever aan bij de hoofdingang?"},
			{"Elwood", "Waarom niet, ik doe alles om mijn grote broer te bevrijden, die ik in mijn hele leven nog nooit gezien heb, en waarvan ik denk dat hij gestoord is omdat hij een miniversie van de Columbia ruimteveer gebouwd heeft."},
			{"Jake", "Ja, zo mag ik het horen. Laten we Brian the Brain bevrijden!"},
		},
		JakesDoorLocked = {
			{"{PLAYER}", "Deze deur zit op slot. Ik moet eerst een sleutel vinden."},
		},
		FightGuards = {
			{"{PLAYER}", "Hallo lui, stoor ik? Ik ben op zoek naar iemand."},
			{"Guard 1", "Wat?! Wat doe je hier! Doe de deur op slot!"},
			{"Guard 2", "Bereid jezelf maar voor op een gevecht."},
		},
		BedTiredBefore = {
			{"{PLAYER}", "Pfff, ik ben bekaf. Even een tukkie doen."},
		},
		BedTiredAfter = {
			{"{PLAYER}", "Ah, dat was geweldig."},
		},
		BedAwake = {
			{"{PLAYER}", "Ik kan hier altijd terug komen om even een tukkie te doen."},
		},
		BedOccupied = {
			{"{PLAYER}", "Ik ga niet samen met hem in een bed slapen!"},
		},
		PrisonDoorLocked = {
			{"{PLAYER}", "Deze deur zit op slot."},
		},
		MessPileNoEngines = {
			{"{PLAYER}", "Dit is een grote berg rotzooi."},
		},
		PushButton = {
			{"{PLAYER}", "Ik druk deze knop in."},
		},
		ButtonOutOfReach = {
			{"{PLAYER}", "Ik kan vanaf hier niet bij de knoppen."},
		},
		PrisonDoorButtonOpen = {
			{"{PLAYER}", "*KLIK* Nu zit de deur waar ik naar binnenkwam niet meer op slot."},
		},
		PrisonDoorButtonClose = {
			{"{PLAYER}", "*KLIK* Nu zit de deur waar ik naar binnenkwam weer op slot."},
		},
		BrianDoorButtonOpen = {
			{"{PLAYER}", "*KLIK* De lampjes lijken aan te geven dat ik net Brians deur heb opengedaan."},
		},
		BrianDoorButtonClose = {

			{"{PLAYER}", "*KLIK* De lampjes lijken aan te geven dat ik net Brians deur heb dichtgedaan."},
		},
		LeverElwood = {
			{"{PLAYER}", "Een, twee, drie!"},
		},
		LeverNotElwood = {
			{"{PLAYER}", "Aargh, deze hendel is roestig. Ik krijg hem niet om. Misschien lukt Elwood dit."},
		},

		-- Conversation tables. Used for random events.
		Guitar = {
			{{"{PLAYER}", "Het is een gitaar!"}},
			{{"{PLAYER}", "Als we niet probeerden de Vierde Wereld Oorlog te voorkomen zou ik er nu meteen op gaan spelen."}},
			{{"{PLAYER}", "Dit lijkt me niet echt een voorwerp dat we nodig hebben voor onze missie."}},
		},
		Keyboard = {
			{{"{PLAYER}", "Laten we wat muziek maken!."}},
			{{"{PLAYER}", "Het is een keyboard."}},
			{{"{PLAYER}", "Het is te groot om mee te nemen."}},
		},
		Poster = {
			{{"{PLAYER}", "Het is een poster."}},
			{{"{PLAYER}", "Het is een poster met een combinatie van hele kleine puntjes. Sommige zijn groen, sommige zijn rood. Andere zijn blauw. Het doel is dat het op afstand een beeld van iets herkenbaars vormt."}},
		},
		Washstand = {
			{{"{PLAYER}", "Het is een wastafel."}},
		},
		Toilet = {
			{{"{PLAYER}", "Het is een toilet, en ongelofelijk vies."}},
		},
		Clock = {
			{{"{PLAYER}", "Het is een klok."}},
		},
		Car = {
			{{"{PLAYER}", "Mooie auto."}},
		},
		Car2 = {
			{{"{PLAYER}", "Deze auto is vernield. O nee, nu moet ik weer aan onze oude Caddy denken..."}},
		},
		DoorLocked = {
			{{"{PLAYER}", "Deze deur zit op slot."}},
			{{"{PLAYER}", "Hij zit op slot."}},
		},
		CantPassFence = {
			{{"{PLAYER}", "Ik kan niet langs dit hek."}},
		},
		LadderOut = {
			{{"{PLAYER}", "Eindelijk een weg naar buiten!"}},
			{{"{PLAYER}", "Laten we gaan!"}},
		},
		LadderIn = {
			{{"{PLAYER}", "Oh nee, we gaan niet terug."}},
			{{"{PLAYER}", "Dit is de verkeerde weg om eruit te komen."}},
		},
		Dustbin = {
			{{"{PLAYER}", "Een prullenbak, daar kunnen de prullen in."}},
			{{"{PLAYER}", "Welke idioot plaatst een prullenbak midden op de stoep?"}},
		},
		Sunflower = {
			{{"Mr. Prosser", "Het is de beroemde Zonnebloem van Vincent van Gogh."}},
			{{"Mr. Prosser", "Betoverend, niet?"}},
			{{"Mr. Prosser", "Raak hem niet aan."}},
		},
		Sunflower2 = {
			{{"{PLAYER}", "Nog een zonnebloem van Van Gogh?!"}},
			{{"{PLAYER}", "Dit is raar..."}},
		},
		MessPile = {
			{{"{PLAYER}", "Dat is een stapel die moeilijk op te ruimen is..."}},
		},
		Soap = {
			{{"{PLAYER}", "Er ligt een zeep op de grond."}},
			{{"{PLAYER}", "Oh nee. Dit is een klassieker. Hier trap ik niet in."}},
			{{"{PLAYER}", "Het is een zeep."}},
		},
		ChristmasTree = {
			{{"{PLAYER}", "Dat is een grote kerstboom!"}},
		},
		CopCar = {
			{{"{PLAYER}", "Dus nu rijden we in een politieauto. Hoe diep kan je zinken..."}},
		},
		Couch = {
			{{"{PLAYER}", "Het is een oude vieze bank."}},
		},
		TV = {
			{{"{PLAYER}", "Deze televisie werkt niet."}},
		},
		Lamppost = {
			{{"{PLAYER}", "It's a lamppost."}},
		},
	};

	defaultproperties = {
		languageName = "Nederlands",
	};
}
