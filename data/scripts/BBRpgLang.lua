--
-- This object holds written text, to easy translation of the game.
--

import("Lang.lua")

BBRpgLang = Lang:subclass
{
	name = "BBRpgLang";

	vars = {
		PLAYER   = "Elwood",
		PLAY     = "Play",
		CREDITS  = "Credits",
		QUIT     = "Quit",
		CONTINUE = "Continue",
	};

	convs = {
				-- Conversations. Used in sequences.
		Intro1 = {
			{"Mr. Prosser", "Standard parole 3 out of 5. Good behavior."},
			{"Mr. Prosser", "Here are your belongings: One Timex digital watch, broken. One unused prophylactic. One soiled. <pause> One pair of sunglasses. Twenty three dollars and seven cents."},
			{"Mr. Prosser", "Sign here please."},
		},
		Intro2 = {
			{"Guard", "Follow me."},
		},
		Intro3 = {
			{"Elwood", "Thank you for your hospitality."},
			{"Guard", "You're welcome. I hope for you I won't see you again."},
			{"Elwood", "We'll see..."},
		},
		Intro4 = {
			{"Jake", "Elwood, over here!"},
		},
		Intro5 = {
			{"Elwood", "Jake, just the weirdest thing is happening!"},
			{"Jake", "What are you talking about?"},
			{"Elwood", "This! Like everything is happening for the second time!"},
			{"Jake", "You just have a deja-vu."},
			{"Elwood", "No, it's like..."},
			{"Jake", "Will you shut up and get in the car?!"},
			{"Elwood", "Okay. But what's this?"},
			{"Jake", "What?"},
			{"Elwood", "This car. This stupid car. Where's the Cadillac? The Caddy? Where's the Caddy?"},
			{"Jake", "The what?"},
			{"Elwood", "The Cadillac we used to have. The Blues Mobile!"},
			{"Jake", "I traded it."},
			{"Elwood", "For a microphone?"},
			{"Jake", "Yes, but how did you..."},
			{"Elwood", "Just a guess."},
			{"Jake", "... Let's get in the car."},
		},
		Intro5a = {
			{"Jake","Here take this walkie talkie. We'll need it to communicate."},
		},
		Intro6 = {
			{"Elwood", "Djeez, these are larger than the GSM's they use in The X-files..."},
			{"Jake", "Listen, we have important things to do."},
			{"Elwood", "Yeah! Putting the band together again!"},
			{"Jake", "No, we did that the last time remember?"},
			{"Elwood", "What are you talking about?"},
			{"Jake", "Uhm, forget what I said."},
			{"Elwood", "But..."},
			{"Jake", "Listen you fucker: we must save Brian."},
			{"Elwood", "Who?"},
			{"Jake", "Brian."},
			{"Elwood", "Who?"},
			{"Jake", "OUR BROTHER BRIAN!"},
			{"Elwood", "Our brother Brian? But we don't have another brother! Especially no Brian!"},
			{"Jake", "He was adopted, now shut up and let me speak!"},
			{"Elwood", "I can't believe mom and dad never told us..."},
			{"Jake", "Told you..."},
			{"Elwood", "What?"},
			{"Jake", "I can't believe mom and dad never told YOU."},
			{"Elwood", "You mean you knew it all the time?"},
			{"Jake", "Yes, but will you please shut up and let me speak!?"},
			{"Jake", "Now, our Brother Brian, alias The Brain, was arrested 2 weeks ago while trying to buy mini-rocket motors in a hobby shop for his 1/100th scale version of the Columbia Spaceshuttle made entirely from mini-rocket engines, ducktape, used walkmans, old wooden popstickles, bicycles and a front-left-car-tire with a stolen creditcard."},
			{"Elwood", "1/100th? That's quite big."},
			{"Jake", "Yes I know, it took him three years just to make a solidrocketbooster suspension handle for the external fueltank."},
			{"Elwood", "Right..."},
			{"Jake", "Anyway, we must get him out of prison! World peace is at stake here!"},
			{"Elwood", "I don't quite see this incident in a global perspective I'm afraid..."},
			{"Jake", "Man, where have you been!?"},
			{"Elwood", "Prison, for a couple of years?"},
			{"Jake", "Right, I almost forgot."},
			{"Jake", "You see, Brian, alias The Brain, is a member of the International Chess Club (..)."},
			{"Elwood", "Ah, I see."},
			{"Jake", "No, ICC."},
			{"Jake", "A friend of Brian, also member of ICC, and owner of a Wall Mart discount plus deluxe card, had asked Brian to get him a 1/100th scale version of the Columbia Spaceshuttle (..)."},
			{"Elwood", "Wait a minute, what does Wall Mart have to do with this?"},
			{"Jake", "Nothing, I just remembered that we need to do some shopping later."},
			{"Jake", "Let me continue. With this 1/100th scale version of the Columbia spaceshuttle, Brian's friend will launch a miniature attack satelite to attack the China-Attack-Satelite-Aimed-At-Washington thus preventing the Fourth World War!"},
			{"Elwood", "Third. Third World War. There've been only two Jake."},
			{"Jake", "What about all the barfights we used to be in? Nothing but foreigners there."},
			{"Elwood", "True..."},
			{"Jake", "So if we do not rescue our big brother, it will be Armageddon!"},
			{"Elwood", "BIG brother? Now you're telling me he's older than us, implying he was adopted before our parents had us."},
			{"Jake", "Yes."},
		},
		Intro7 = {
			{"Jake", "So, here we are!"},
			{"Elwood", "Where are we?"},
			{"Jake", "My neighbourhood! My appartement is right over there!"},
			{"Elwood", "Let's get to work."},
		},
		WhereKeys = {
			{"Jake", "Elwood, did I give my keys of my appartement to you?"},
			{"Elwood", "Didn't you?"},
			{"Jake", "Did I?"},
			{"Elwood", "No."},
			{"Jake", "Hmm, they must have fallen out of my pockets while I was taking a stroll before picking you up. We must find them, my crowbar is in my house. We'll need it."},
		},
		AtJakesPlace = {
			{"Jake", "Welcome in Case-del-Jake!"},
			{"Elwood", "Man, this place stinks..."},
			{"Elwood", "Literally."},
			{"Jake", "Does it? Never noticed it."},
		},
		AtJakesPlace2 = {
			{"Jake", "This place is a dumb."},
			{"Elwood", "It's better than the hellhole you lived in the past couple of years."},
		},
		FindKeyFob = {
			{"Jake", "There it is! My lucky key fob!"},
			{"Elwood", "You're telling me we went through all this trouble just to get your tentacle key fob?"},
			{"Jake", "Yes! It's very special to me! It brought me luck!"},
			{"Elwood", "You call this luck?"},
			{"Jake", "Shut up."},
		},
		FindBrian1Jake = {
			{"Jake", "Brian!"},
			{"Brian", "Jake!"},
			{"Jake", "Here, take this walkie talkie to communicate with us."},
		},
		FindBrian2Jake = {
			{"Brian", "Us?"},
			{"Elwood", "Brian!"},
			{"Brian", "Who are you?"},
			{"Elwood", "I'm your other brother!"},
			{"Brian", "I've another brother?"},
			{"Jake", "Yes, he's adopted."},
			{"Elwood", "What?"},
			{"Brian", "I can't believe mom and dad never told us!"},
			{"Jake", "Told you."},
			{"Brian", "What?"},
			{"Jake", "I can't believe mom and dad never told YOU <sigh>."},
			{"Brian", "You knew?"},
			{"Brian", "Then again, I can't believe mom and dad never told him that he's adopted."},
			{"Elwood", "You're the adopted one, I'm a genuine Blues Brother!"},
			{"Jake", "Please shut up both of you. Let's get the hell out of here."},
		},
		FindBrian1Elwood = {
			{"Elwood", "Brian!"},
			{"Brian", "Who are you? You look like a small fat copy of Jake."},
			{"Elwood", "I'm your other brother!"},
			{"Brian", "I've another brother?"},
			{"Elwood", "If you don't believe it, you can ask Jake for it with this walkie talkie."},
		},
		FindBrian2Elwood = {
			{"Jake", "Brian!"},
			{"Brian", "I've another brother?"},
			{"Jake", "Yes, he's adopted."},
			{"Elwood", "What?"},
			{"Brian", "I can't believe mom and dad never told us!"},
			{"Jake", "Told you."},
			{"Brian", "What?"},
			{"Jake", "I can't believe mom and dad never told YOU <sigh>."},
			{"Brian", "You knew?"},
			{"Brian", "Then again, I can't believe mom and dad never told him that he's adopted."},
			{"Elwood", "You're the adopted one, I'm a genuine Blues Brother!"},
			{"Jake", "Please shut up both of you. Let's get the hell out of here."},
		},
		EscapedInAppartment = {
			{"Brian", "Man, this place is a dumb!"},
			{"Elwood", "I already told him that. He calls this 'luck'."},
			{"Brian", "Maybe he is the adopted one."},
			{"Jake", "What?"},
			{"Elwood", "Nothing."},
			{"Brian", "Okay, let's get to business. We must prevent the outbreak of the Fourth World War!"},
			{"Elwood", "But how?"},
			{"Brian", "Al I need are my mini-rocket engines, and give them to Lee!"},
			{"Jake", "Who's Lee?"},
			{"Brian", "He's the one with the Wall Mart Discount Plus Deluxe Card."},
			{"Elwood", "Ofcourse, Lee!"},
			{"Jake", "And where are the mini-rocket engines?"},
			{"Brian", "Err, well, that may be a problem. I hid them in a mess pile just before I was arrested..."},
			{"Elwood", "Well that's just great. And how are we supposed to find it?"},
			{"Brian", "I guess we'd better start looking."}
		},
		FindMiniRocketEngines = {
			{"{PLAYER}", "I found them. The mini-rocket engines are here."},
			{"Brian", "Okay, that's great. Let's go to Lee and give it to him. He lives in the southwestern part of the suburbs at the 'Planetenlaan 192'."},
			{"Jake", "Okay."},
			{"Elwood", "See you there."},
		},
		Ending1 = {
			{"Brian", "Lee!"},
			{"Lee", "Hi."},
			{"Elwood", "This is Lee?"},
			{"Jake", "By assuming Brian knows the man, and the fact that Brian called him Lee, I'm pretty certain he is Lee."},
			{"Lee", "Indeed, I'm the one who's called Lee."},
			{"Brian", "We have the mini-rocket engines for the 1/100th scale version of the Columbia spaceshuttle which will carry your mini-attack satalite into space which will in his turn prevent the Fourth World War! Here you are."},
		},
		Ending2 = {
			{"Lee", "Okay, that's great! By the way, it's the Fifth World War."},
			{"Elwood", "Oh no, not again..."},
			{"Jake", "Fifth? Bar fights?"},
			{"Lee", "Indeed."},
			{"Elwood", "Well?"},
			{"Jake", "What?"},
			{"Elwood", "Shouldn't Lee do what he is suppost to do, while we go home, forget this dreadfull mission ever happened, and make some music?"},
			{"Jake", "Good plan."},
			{"Elw00t", "Why don't the three of us start a band?"},
		},		
		WallAndTubeElwood = {
			{"{PLAYER}", "I can't get in the tube. It's to damn small!"},
		},
		WallAndTube1 = {
			{"{PLAYER}", "I'm gonna crawl in this tube."},
		},
		WallAndTube2 = {
			{"{PLAYER}", "Finally, the exit."},
		},
		TooDangerous = {
			{"{PLAYER}", "I'd better not come too near these guys..."},
		},
		RemovePutdeksel = {
			{"{PLAYER}", "Ah yes, it's moving... Good thing we memorized the sewer system."},
		},
		CantRemovePutdeksel = {
			{"{PLAYER}", "It won't move. I need a tool to remove it."},
		},
		Crowbar = {
			{"{PLAYER}", "There's a crowbar."},
			{"Jake", "That's great. We will be needing it to enter the sewers."},
			{"Elwood", "What? The sewers?!"},
			{"Jake", "Yeah, what else? Do you prefer to knock on the front door?"},
			{"Elwood", "Why not, I'd do anything to free our big brother, who I've never seen in my entire life, and who I think is a big nutcase building a 1/100th scaled version of the Columbia spaceshuttle."},
			{"Jake", "Yeah, that's the spirit! Let's free Brian the Brain!"},
		},
		JakesDoorLocked = {
			{"{PLAYER}", "This door is locked. I need to find the key first."},
		},
		FightGuards = {
			{"{PLAYER}", "Hi guys, do I interrupt? I am looking for someone."},
			{"Guard 1", "What?! What are you doing here! Lock the door!"},
			{"Guard 2", "Prepare for combat."},
		},
		BedTiredBefore = {
			{"{PLAYER}", "Djeez, I'm wasted. Let's take a nap."},
		},
		BedTiredAfter = {
			{"{PLAYER}", "Ah, that was great."},
		},
		BedAwake = {
			{"{PLAYER}", "I can always return here to take a nap."},
		},
		BedOccupied = {
			{"{PLAYER}", "I'm not going to sleep together with him in one bed!"},
		},
		PrisonDoorLocked = {
			{"{PLAYER}", "This door is locked."},
		},
		MessPileNoEngines = {
			{"{PLAYER}", "It's a huge pile of mess."},
		},
		PushButton = {
			{"{PLAYER}", "Let's push this button."},
		},
		ButtonOutOfReach = {
			{"{PLAYER}", "I cannot reach the buttons from this side of the control panel."},
		},
		PrisonDoorButtonOpen = {
			{"{PLAYER}", "*PUSH* Now I have unlocked the door through which I entered."},
		},
		PrisonDoorButtonClose = {
			{"{PLAYER}", "*PUSH* Now I have locked the door through which I entered."},
		},
		BrianDoorButtonOpen = {
			{"{PLAYER}", "*PUSH* The lights seem to indicate I've just opened Brian's door."},
		},
		BrianDoorButtonClose = {
			{"{PLAYER}", "*PUSH* The lights seem to indicate I've just closed Brian's door."},
		},
		LeverElwood = {
			{"{PLAYER}", "One, two, three!"},
		},
		LeverNotElwood = {
			{"{PLAYER}", "Damn, these levers are rusty. I can't pull them... Maybe Elwood can."},
		},

		-- Conversation tables. Used for random events.
		Guitar = {
			{{"{PLAYER}", "It's a guitar!"}},
			{{"{PLAYER}", "If we weren't trying to prevent the Fourth World War, I would play it right now, right here. Whatever, I'll try it anyway."}},
			{{"{PLAYER}", "This isn't really an item that will assist us in the success of our mission."}},
		},
		Keyboard = {
			{{"{PLAYER}", "Let's play some blues."}},
			{{"{PLAYER}", "Let's make some music."}},
			{{"{PLAYER}", "It's a keyboard."}},
			{{"{PLAYER}", "It's too big to carry along."}},
			{{"{PLAYER}", "I still got the blues..."}},
		},
		Poster = {
			{{"{PLAYER}", "It's a poster."}},
			{{"{PLAYER}", "It's a poster featuring a certain combination of very small dots, some green, some red, some blue, with the purpose of forming a image when viewed from a distance."}},
		},
		Washstand = {
			{{"{PLAYER}", "It's a washstand."}},
		},
		Toilet = {
			{{"{PLAYER}", "It's a toilet. Dawm, it's dirty."}},
		},
		Clock = {
			{{"{PLAYER}", "It's a clock."}},
		},
		Car = {
			{{"{PLAYER}", "Nice car."}},
		},
		Car2 = {
			{{"{PLAYER}", "This car is trashed. Oh no, now I have to think of our old caddy again..."}},
		},
		DoorLocked = {
			{{"{PLAYER}", "This door is locked."}},
			{{"{PLAYER}", "It is locked."}},
		},
		CantPassFence = {
			{{"{PLAYER}", "I can't pass this fence."}},
		},
		LadderOut = {
			{{"{PLAYER}", "A finally, we found a way out!"}},
			{{"{PLAYER}", "Let's go!"}},
		},
		LadderIn = {
			{{"{PLAYER}", "No way, we're not going back."}},
			{{"{PLAYER}", "This is the wrong way to get out of here."}},
		},
		Dustbin = {
			{{"{PLAYER}", "A dustbin, it's where the dust goes."}},
			{{"{PLAYER}", "What moron would put a dustbin in the middle of the sidewalk?"}},
		},
		Sunflower = {
			{{"Mr. Prosser", "It's the famous sunflower of Vincent van Gogh."}},
			{{"Mr. Prosser", "Beautiful isn't it?"}},
			{{"Mr. Prosser", "Don't touch it."}},
		},
		Sunflower2 = {
			{{"{PLAYER}", "Another Sunflower of van Gogh?!"}},
			{{"{PLAYER}", "This is weird..."}},
		},
		MessPile = {
			{{"{PLAYER}", "Wow, here's a pile that's hard to clean up."}},
		},
		Soap = {
			{{"{PLAYER}", "There is a soapbar lying at the floor."}},
			{{"{PLAYER}", "Oh, no. This one is a classic. You don't fool me."}},
			{{"{PLAYER}", "It's a soapbar."}},
		},
		ChristmasTree = {
			{{"{PLAYER}", "That's one huge Christmas tree!"}},
		},
	};
}
