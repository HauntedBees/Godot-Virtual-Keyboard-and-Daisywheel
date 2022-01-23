# Godot 3.4 Virtual Keyboard and Daisywheel
A virtual on-screen keyboard supporting gamepad and mouse-based input as well as a daisywheel supporting gamepad input.

# Installation
Copy `addons/keyboard_daisy` into your project (final path should be `res://addons/keyboard_daisy`). In the Godot Editor, go to **Project Settings > Plugins** and enable the **Virtual Keyboard + Daisywheel** plugin. You can now add **Daisywheel** and **VirtualKeyboard** nodes to your project.

# Daisywheel
It's a daisywheel for gamepad-based text input! Just like the good old days! If you don't know what a daisywheel is, it's a gamepad-centric input method where you can use the left analog stick to choose one of eight "petals" and then press one of the four face buttons to type that letter. For some people it can be much easier and faster than manually navigating across a virtual keyboard, letter by letter, to type something.

## Export Variables

### Main Set
A string of at most 32 characters that will be displayed and accessible by default.

### Capital Set
A string of at most 32 characters that will be displayed and accessible when the Right Trigger (R2, RT, ZR) is held down.

### Numeric Set
A string of at most 32 characters that will be displayed and accessible when the Left Trigger (L2, LT, ZL) is held down.

### Gamepad Index
The index of the gamepad to use for input handling.

### Dead Zone
The analog stick deadzone for analog stick input to be registered.

## Customization
You can tweak any of the `.tscn` files in `res://addons/keyboard_daisy/parts/` to change the petal texture, button texture, display font, and info text.

# VirtualKeyboard
Coming soon.
# License

Copyleft, but, like, whatever. If you've read this far and you're some new indie gamedev or something who really thinks this code will help you but for some reason you're very determined not to open source your game for whatever reason, I think that's weird but realistically don't care. If your game or project makes less than $1,000 or something, you can interpret this as me granting you a license to use this code in your proprietary game. If your project makes more than that, either release its source under a license compatible with the AGPLv3, take my code out of your project, or send me ten bucks.

The font [Ulagadi Sans](https://fontlibrary.org/en/font/ulagadi-sans) is licensed under the [SIL Open Font License](https://scripts.sil.org/cms/scripts/page.php?site_id=nrsi&id=OFL).