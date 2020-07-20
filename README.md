<<<<<<< HEAD

It was at this moment VikFro didn't know, he fucked up:

```# TODO: Finite State Machine?```


# Mac(a)ron Simulator (GMTK 2020 "Out of Control" & Godot Wild Jam 23 "MiniWorld")
https://itch.io/jam/gmtk-deadline-missers-jam/rate/700439

https://frovik.itch.io/mokron-simulator

90% livecoded at https://twitch.tv/vikfro

I will probably abandon this idea and focus on doing Olegna in Godot, with a multiplayer twin-stick top-down A-RPG gameplay!

Simple sandbox "RTS" where your units have morale and hidden mechanics that impact it, which you have to figure out :)

I did not have time to implement a true game loop and a goal, so you can just toy around and see how bugged it is.
 
When it reaches the behaviour of the unit changes and it will start picking fights with its allies. 

You can select and babysit only one unit at a time, and when a unit is not selected, the wonky self-destructive AI takes control and wrecks havoc!


# Attack of the Macrabron(s)! Adaptation to submit to Godot Wild Jam 23 "MiniWorld"
## TODO: 
- fix the things I break every time I add a new mechanic
- Why did I try to implement BOTH automatic AI & user control? :'(
- remove the "out of control-ness"
    - better navigation
    - units stop fighting each other
- more serious & less political theme? I don't know, like including a Macaron boss that you decapi...cut in half!
- MACRABRON THE BOSS TO KILL WITH YOUR UNITS! BE CAREFUL, HE TRANSFORMS YOUR UNITS BACK INTO WORKERS WITH HIS MONEY ATTACK!

1. macrabron aggro toutes les unités, à la fois gilet jaune et travailleurs
2. il y a des money printers qu'on peut utiliser pour spawn plus d'unités
3. zone safe boss kitable derrière les arbres, mais il retarget après un certain temps bloqué
4. les money printers respawnent (et sont temporaires?), jusqu'à un certain max et toujours au moins un certain nombre mini
5. hors de sa zone d'aggro, macrabron marche comme un crabe. seulement horizontalement (peut-être un peu de biais)


- lose screen if all your units die
- retransfo worker at 50 morale? (100?)
- move kill (=unit death) sound to Macrabron


## UX improvements
- assign units to hotkeys


## Ideas:
1. Make a real game? Could reuse the Zombinvasion idea. Or:
- JUICE!
2. design the AI with a calmhead, rewrite it with a clean Finite State Machine or something similar. So it behaves less erratically
3. gain morale while fighting
- JUICE!
4. remove gilet jaune when reaching 100 morale
5. flee AI when being beaten up / lose morale
- JUICE!- JUICE!- JUICE!- JUICE!- JUICE!

- gain morale while fighting / getting thrown money at your face
- link ends of screens horizontally and vertically (portals)
- flee AI when being beaten up / lose morale
- JUICE or idle AI to be continued OR combat mechanic

- morale out-of-control
    - fighting reduces it,
    - someone else harvesting food from the same machine as you reduces it

- NO multiple unit management! Because I don't have time and it's more "fun" to micromanage your baby units doing whatever they want


### "juice" & random shit
- animation Pokémon evolve-like between two sprites when transitioning to gilet

- boire de la 86

- happy skin chemise hawaienne short tongs

- make units fatter & slower by modifying X scale if they eat too much

- make units fatter by modifying X scale if they eat too much

- Guillotine to quit the game


# Technical / clean code stuff:
throw errors instead of print for bugs (null pointers)
