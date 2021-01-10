
## Using
Just run 
```sh
bash install.sh
```

## Background

1. Create a new symbols file, the required symbol definitions.
2. Copy or link it to `/usr/share/X11/xkb/symbols`. This is required due to how XKB works:

    > An XKB keymap is constructed from a number of components which are compiled only as needed.  The source for all of the components can be found in /usr/share/X11/xkb.
3. View your current configuration. There are two options here, a user friendly version
    ```sh
    $ setxkbmap -query    
    rules:      evdev
    model:      pc105
    layout:     us
    options:    caps:escape,compose:ralt
    ```
    Here we see a vew things:

    * The rules references a file `/usr/share/X11/xkb/rules` that (from what I understand) contains a long list of various configuration defaults. 
    * The model is referencing a physical keyboard geometry, In Gnome, go to `Settings > Region & Language` and then click the eyeball next to the input source, this will show a picture of physical keyboard. This does not 100% have to match your actual keyboard, but it will be _very_ close. 
    * The layout is the thing we actually want to modify. In my case, it says I am using a US keyboard. This is also seen in the screenshot above.
    * The options are modifications that I set via Gnome Tweak, in this case mapping Caps Lock to Escape and the compose key is the right Alt.

    Altneratively, you can get the same information as a "reusable" output, this can be piped into xkbcomp, e.g. over ssh to a client shell (according to the man page)

    ```sh
    $ setxkbmap -print
    xkb_keymap {
        xkb_keycodes  { include "evdev+aliases(qwerty)"	};
        xkb_types     { include "complete"	};
        xkb_compat    { include "complete"	};
        xkb_symbols   { include "pc+us+inet(evdev)+capslock(escape)+compose(ralt)"	};
        xkb_geometry  { include "pc(pc105)"	};
    };
    ```

4. Enable the new layout
    ```sh
    $ setxkbmap xps
    ```
    there is no output. But we can verify that the configuration 
    ```sh
    $ setxkbmap -query    
    rules:      evdev
    model:      pc105
    layout:     xps
    options:    caps:escape,compose:ralt
    ```

5. Making the setting permanent.  I have found two suggestsions for how to make this setting persist across logins. so far, I have only seen the first option work as expected.

    1. First, you can create/edit your `$HOME/.profile` to add `setxkbmap xps` to the end. This file contains commands that are applied when you session starts.

    2. Second, I can not confirm that this works. supposedly, you can modify your settings using `gsettings`

    ```sh
    $ gsettings get org.gnome.desktop.input-sources sources
    [('xkb', 'us')]
    $ gsettings set org.gnome.desktop.input-sources sources "[('xkb','xps')]"
    ```

    In this second option, you can also see and set via `dconf`, for example

    ```sh
    $ dconf dump /org/gnome/desktop/input-sources/
    [/]
    current=uint32 0
    show-all-sources=true
    sources=[('xkb', 'xps')]
    xkb-options=['caps:escape', 'compose:ralt']
    ```
    But I found `gsettings` easier to use. 

Warning. I tried using _just_ option 2, but it didn't work after a reboot. Howerver, it _does_ change my input source in the Settings app to be `xps` instead of `us`. This seems like a good thing, so I have done both (1) and (2). This way, if anything tries to modify the keyboard settings and uses this value, it will get the correct value.

    
References:

[niklas]: https://niklasfasching.de/posts/custom-keyboard-layout/ 
[damko]: http://people.uleth.ca/~daniel.odonnell/Blog/custom-keyboard-in-linuxx11
[askubuntu]: https://askubuntu.com/questions/369276/add-remove-keyboard-layout-by-console-command
[unixoverlow]: https://unix.stackexchange.com/questions/99085/save-setxkbmap-settings


[technical-writing]: https://github.com/rubymorillo/pocket-tech-writing-list