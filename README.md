
It was at this moment VikFro didn't know, he fucked up:

```# TODO: Finite State Machine?```

# Macaron Simulator (GMTK 2020 "Out of Control")
Simple RTS where your units have a hidden morale and hidden mechanics that impact it, which you have to figure out :)
 
Below certain thresholds the behaviour of the unit changes and it can start picking fights with its allies or destroy buildings etc.
 
=> The player loses the control you usually have in a RTS game, and has to adapt to the new configuration

# Attack of the Macrabron(s)! Adaptation to submit to Godot Wild Jam 23 "MiniWorld"
## TODO: 
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


- retransfo worker at 50 morale? (100?)
- move kill (=unit death) sound to Macrabron



## Ideas:

- gain morale while fighting / getting thrown money at your face
- link ends of screens horizontally and vertically (portals)
- flee AI when being beaten up / lose morale
- JUICE or idle AI to be continued OR combat mechanic

- morale out-of-control
    - fighting reduces it,
    - someone else harvesting food from the same machine as you reduces it

- NO multiple unit management! Because I don't have time and it's more "fun" to micromanage your baby units doing whatever they want

## Themed UI/UX, "juice" & random shit
- animation Pokémon evolve-like between two sprites when transitioning to gilet

- boire de la 86

- skin content chemise hawaienne short tongs

- make units fatter & slower by modifying X scale if they eat too much


# Technical / clean code stuff:
throw errors instead of print for bugs (null pointers)