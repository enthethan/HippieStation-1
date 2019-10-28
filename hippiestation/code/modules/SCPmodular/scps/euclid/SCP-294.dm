GLOBAL_LIST_EMPTY(scp294_reagents)

/obj/machinery/scp294
	name = "SCP-294"
	desc = "A standard coffee vending machine."
	icon = 'hippiestation/icons/mob/scpicon/scpobj/scp294.dmi'
	icon_state = "coffee_294"
	layer = 2.9
	anchored = 1
	density = 1
	var/uses_left = 5000
	var/last_use = 0
	var/restocking_timer = 0

/obj/machinery/scp294/New()
	..()

	if(!GLOB.scp294_reagents.len)
		//Chemical Reagents - Initialises all /datum/reagent into a list indexed by reagent id
		var/paths = subtypesof(/datum/reagent) - /datum/reagent/medicine/adminordrazine
		for(var/path in paths)
			var/datum/reagent/D = new path
			GLOB.scp294_reagents[D.name] = D

/obj/machinery/scp294/examine(mob/user)
	to_chat(user, "<span class='notice'>SCP 294, Glorified Chem Dispenser</span>")

/obj/machinery/scp294/attack_hand(mob/user)

	if((last_use + 3 SECONDS) > world.time)
		visible_message("<span class='notice'>[src] displays NOT READY message.</span>")
		return

	last_use = world.time
	if(uses_left < 1)
		visible_message("<span class='notice'>[src] displays RESTOCKING, PLEASE WAIT message.</span>")
		uses_left = 2000
		return

	var/product = null
	var/input_reagent = (input("Enter the name of any liquid") as text)
	product = find_reagent(input_reagent)

	if(product)
		var/obj/item/reagent_containers/glass/D = new /obj/item/reagent_containers/glass(loc)
		D.reagents.add_reagent(product, 30)
		visible_message("<span class='notice'>[src] dispenses a small paper cup.</span>")
	else
		visible_message("<span class='notice'>[src]'s OUT OF RANGE light flashes rapidly.</span>")

/obj/machinery/scp294/proc/find_reagent(input)
	. = FALSE
	if(GLOB.scp294_reagents[input])
		var/datum/reagent/R = GLOB.scp294_reagents[input]
		if(R)
			return R.type
	else
		for(var/X in GLOB.scp294_reagents)
			var/datum/reagent/R = GLOB.scp294_reagents[X]
			if (ckey(input) == ckey(R.name))
				return R.type
