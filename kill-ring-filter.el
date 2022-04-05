(defvar kill-ring-filter-timer nil "Saves the idle-timer that runs the filter function.")

(defun kill-ring-filter-timer-cancel ()
  (when kill-ring-filter-timer
    (cancel-timer kill-ring-filter-timer)))

(defcustom kill-ring-filter-timeout 60 "Number of seconds after kill-new was run until the kill-ring is cleared.")
;;(setq kill-ring-filter-timeout 60)

(defconst kill-ring-filter-nsfw-words-en
  (let ((words "2g1c
2 girls 1 cup
acrotomophilia
alabama hot pocket
alaskan pipeline
anal
anilingus
anus
apeshit
arsehole
ass
asshole
assmunch
auto erotic
autoerotic
babeland
baby batter
baby juice
ball gag
ball gravy
ball kicking
ball licking
ball sack
ball sucking
bangbros
bangbus
bareback
barely legal
barenaked
bastard
bastardo
bastinado
bbw
bdsm
beaner
beaners
beaver cleaver
beaver lips
beastiality
bestiality
big black
big breasts
big knockers
big tits
bimbos
birdlock
bitch
bitches
black cock
blonde action
blonde on blonde action
blowjob
blow job
blow your load
blue waffle
blumpkin
bollocks
bondage
boner
boob
boobs
booty call
brown showers
brunette action
bukkake
bulldyke
bullet vibe
bullshit
bung hole
bunghole
busty
butt
buttcheeks
butthole
camel toe
camgirl
camslut
camwhore
carpet muncher
carpetmuncher
chocolate rosebuds
cialis
circlejerk
cleveland steamer
clit
clitoris
clover clamps
clusterfuck
cock
cocks
coprolagnia
coprophilia
cornhole
coon
coons
creampie
cum
cumming
cumshot
cumshots
cunnilingus
cunt
darkie
date rape
daterape
deep throat
deepthroat
dendrophilia
dick
dildo
dingleberry
dingleberries
dirty pillows
dirty sanchez
doggie style
doggiestyle
doggy style
doggystyle
dog style
dolcett
domination
dominatrix
dommes
donkey punch
double dong
double penetration
dp action
dry hump
dvda
eat my ass
ecchi
ejaculation
erotic
erotism
escort
eunuch
fag
faggot
fecal
felch
fellatio
feltch
female squirting
femdom
figging
fingerbang
fingering
fisting
foot fetish
footjob
frotting
fuck
fuck buttons
fuckin
fucking
fucktards
fudge packer
fudgepacker
futanari
gangbang
gang bang
gay sex
genitals
giant cock
girl on
girl on top
girls gone wild
goatcx
goatse
god damn
gokkun
golden shower
goodpoop
goo girl
goregasm
grope
group sex
g-spot
guro
hand job
handjob
hard core
hardcore
hentai
homoerotic
honkey
hooker
horny
hot carl
hot chick
how to kill
how to murder
huge fat
humping
incest
intercourse
jack off
jail bait
jailbait
jelly donut
jerk off
jigaboo
jiggaboo
jiggerboo
jizz
juggs
kike
kinbaku
kinkster
kinky
knobbing
leather restraint
leather straight jacket
lemon party
livesex
lolita
lovemaking
make me come
male squirting
masturbate
masturbating
masturbation
menage a trois
milf
missionary position
mong
motherfucker
mound of venus
mr hands
muff diver
muffdiving
nambla
nawashi
negro
neonazi
nigga
nigger
nig nog
nimphomania
nipple
nipples
nsfw
nsfw images
nude
nudity
nutten
nympho
nymphomania
octopussy
omorashi
one cup two girls
one guy one jar
orgasm
orgy
paedophile
paki
panties
panty
pedobear
pedophile
pegging
penis
phone sex
piece of shit
pikey
pissing
piss pig
pisspig
playboy
pleasure chest
pole smoker
ponyplay
poof
poon
poontang
punany
poop chute
poopchute
porn
porno
pornography
prince albert piercing
pthc
pubes
pussy
queaf
queef
quim
raghead
raging boner
rape
raping
rapist
rectum
reverse cowgirl
rimjob
rimming
rosy palm
rosy palm and her 5 sisters
rusty trombone
sadism
santorum
scat
schlong
scissoring
semen
sex
sexcam
sexo
sexy
sexual
sexually
sexuality
shaved beaver
shaved pussy
shemale
shibari
shit
shitblimp
shitty
shota
shrimping
skeet
slanteye
slut
s&m
smut
snatch
snowballing
sodomize
sodomy
spastic
spic
splooge
splooge moose
spooge
spread legs
spunk
strap on
strapon
strappado
strip club
style doggy
suck
sucks
suicide girls
sultry women
swastika
swinger
tainted love
taste my
tea bagging
threesome
throating
thumbzilla
tied up
tight white
tit
tits
titties
titty
tongue in a
topless
tosser
towelhead
tranny
tribadism
tub girl
tubgirl
tushy
twat
twink
twinkie
two girls one cup
undressing
upskirt
urethra play
urophilia
vagina
venus mound
viagra
vibrator
violet wand
vorarephilia
voyeur
voyeurweb
voyuer
vulva
wank
wetback
wet dream
white power
whore
worldsex
wrapping men
wrinkled starfish
xx
xxx
yaoi
yellow showers
yiffy
zoophilia"))
    (split-string words "
" t " "))
  "A list of bad words from https://github.com/LDNOOBW/List-of-Dirty-Naughty-Obscene-and-Otherwise-Bad-Words. Creative Commons Attribution 4.0 International, but I couldn't figure out the author. See https://github.com/LDNOOBW/List-of-Dirty-Naughty-Obscene-and-Otherwise-Bad-Words/blob/master/LICENSE")

(defcustom kill-ring-filter-filter-res kill-ring-filter-nsfw-words-en "List of regular expressions that are used to filter kill-ring entries")

(defun kill-ring-filter-filter-string (s)
  "t if S is matched by anything in kill-ring-filter-filter-res."
  (let ((filtered-p t))
    (catch 'break
      (dolist (re kill-ring-filter-filter-res filtered-p)
        (when (string-match-p re s)
          ;;(message "filtering '%s' by '%s'" s re)
          (setq filtered-p nil)
          (throw 'break t))))
    filtered-p))

;;(kill-ring-filter-filter-string "bar")

(defun kill-ring-filter ()
  "Remove entries in kill-ring if they are matched by anything in kill-ring-filter-filter-res."
  (interactive)
  (setq kill-ring (seq-filter #'kill-ring-filter-filter-string kill-ring)))

(defun kill-ring-filter-advice (&rest args)
  (kill-ring-filter-timer-cancel)
  (setq kill-ring-filter-timer (run-with-timer kill-ring-filter-timeout nil #'kill-ring-filter)))


;;;###autoload
(define-minor-mode kill-ring-filter-mode
  "Remove entries in the kill-ring if any regular expression in kill-ring-filter-filter-res matches."
  :lighter " krfilt"
  :global t
  (kill-ring-filter-timer-cancel)
  (if kill-ring-filter-mode
      (advice-add 'kill-new :after #'kill-ring-filter-advice)
    (advice-remove 'kill-new #'kill-ring-filter-advice)))

;;;###autoload
;;(add-hook 'text-mode-hook 'foo-mode)

(provide 'kill-ring-filter)
