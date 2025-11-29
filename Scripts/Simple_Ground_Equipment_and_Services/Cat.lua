-- Simuler le comportement d'un chat
math.randomseed(os.time())  -- Initialiser la graine aléatoire
Cat_timer = os.time()

local Cat = {
    name = "Mittens",
    energy = 100,   -- Niveau d'énergie (0 à 100)
    hunger = 0,     -- Niveau de faim (0 à 100)
    mood = "playful",  -- État d'esprit actuel
}

-- Actions possibles
function Cat:meow()
    print(self.name .. " says: Meow!")
end

function Cat:nap()
    print(self.name .. " curls up and naps. 💤")
    self.energy = math.min(self.energy + 30, 100)
    self.mood = "calm"
    self.hunger = math.min(self.hunger + 10, 100)
end

function Cat:eat()
    print(self.name .. " munches on some kibble. 🍗")
    self.hunger = math.max(self.hunger - 30, 0)
    self.energy = math.min(self.energy + 10, 100)
    self.mood = "satisfied"
end

function Cat:play()
    if self.energy > 20 then
        print(self.name .. " pounces on a toy mouse! 🐭")
        self.energy = self.energy - 20
        self.hunger = math.min(self.hunger + 15, 100)
        self.mood = "excited"
    else
        print(self.name .. " is too tired to play.")
        self:nap()
    end
end

function Cat:random_behavior()
    local behaviors = {"meow", "nap", "eat", "play"}
    local choice = behaviors[math.random(#behaviors)]
    self[choice](self)
end

-- Mettre à jour l'état du chat
function Cat:update()
    self.hunger = math.min(self.hunger + 1, 100)
    if self.hunger >= 70 then
        self.mood = "hungry"
        print(self.name .. " looks at you with pleading eyes. 😿")
    end
    if self.hunger == 100 then
        print(self.name .. " is very hungry and meows loudly! 🐾")
    end
    if self.energy <= 10 then
        self.mood = "tired"
    end
end

-- Simulation
--~ print("Meet " .. Cat.name .. ", your virtual cat! 🐈")
function Cat_acting()
	if os.time() > Cat_timer + 600 then
		--print("\n-- Minute " .. i .. " --")
		Cat:update()
		Cat:random_behavior()
		logMsg("Energy: " .. Cat.energy .. " | Hunger: " .. Cat.hunger .. " | Mood: " .. Cat.mood .. " Thanks for taking care of " .. Cat.name .. " the cat ! 🐈")
		--~ logMsg("Thanks for taking care of " .. Cat.name .. " the cat ! 🐈")
		Cat_timer = os.time()
	end
end
--~ do_sometimes("Cat_acting()")
