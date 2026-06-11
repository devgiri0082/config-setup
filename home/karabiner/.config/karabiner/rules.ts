import fs from "fs";
import { KarabinerRules } from "./types";
import { app, createHyperSubLayers, open } from "./utils";

const rules: KarabinerRules[] = [
  // Remap Control + Y to Enter only in VSCode/Cursor
  {
    description: "Control + Y to Enter (VSCode/Cursor only)",
    manipulators: [
      {
        type: "basic",
        from: {
          key_code: "y",
          modifiers: {
            mandatory: ["control"],
            optional: ["any"],
          },
        },
        to: [
          {
            key_code: "return_or_enter",
          },
        ],
        conditions: [
          {
            type: "frontmost_application_if",
            bundle_identifiers: [
              "^com\\.microsoft\\.VSCode$",
              "^com\\.todesktop\\.230313mzl4w4u92$",
              "^dev\\.zed\\.Zed$",
            ],
          },
        ],
      },
    ],
  },
  // Define the Hyper key itself
  {
    description: "Hyper Key (⌃⌥⇧⌘)",
    manipulators: [
      {
        description: "Caps Lock -> Hyper Key",
        from: {
          key_code: "caps_lock",
          modifiers: {
            optional: ["any"],
          },
        },
        to: [
          {
            set_variable: {
              name: "hyper",
              value: 1,
            },
          },
        ],
        to_after_key_up: [
          {
            set_variable: {
              name: "hyper",
              value: 0,
            },
          },
        ],
        to_if_alone: [
          {
            key_code: "escape",
          },
        ],
        type: "basic",
      },
    ],
  },
  ...createHyperSubLayers({
    spacebar: open(
      "raycast://extensions/stellate/mxstbr-commands/create-notion-todo"
    ),
    // Most used applications
    "0": app("Ghostty"), // Terminal
    "9": app("Google Chrome"), // Chrome
    "8": app("Zed"),
    "7": app("Notion"), // Notion
    "6": app("Clockify Desktop"), // Clockify
    // b = "B"rowse
    b: {
      y: open("https://www.youtube.com"),
      f: open("https://facebook.com"),
      r: open("https://reddit.com"),
      s: open("https://spotify.com"),
      t: open("https://trello.com"),
      v: open("https://vercel.com"),
    },
    // o = "Open" applications
    o: {
      g: app("Google Chrome"),
      e: app("Microsoft Edge"),
      c: app("Cursor"),
      n: app("Notion"),
      d: app("Discord"),
      s: app("Slack"),
      t: app("Ghostty"),
      m: app("Mail"),
      f: app("Finder"),
      i: app("Insomnia"),
      w: app("WhatsApp"),
      l: open(
        "raycast://extensions/stellate/mxstbr-commands/open-mxs-is-shortlink"
      ),
    },

    // s = "System"
    s: {
      u: {
        to: [
          {
            key_code: "volume_increment",
          },
        ],
      },
      j: {
        to: [
          {
            key_code: "volume_decrement",
          },
        ],
      },
      i: {
        to: [
          {
            key_code: "display_brightness_increment",
          },
        ],
      },
      k: {
        to: [
          {
            key_code: "display_brightness_decrement",
          },
        ],
      },
      l: {
        to: [
          {
            key_code: "q",
            modifiers: ["right_control", "right_command"],
          },
        ],
      },
      p: {
        to: [
          {
            key_code: "play_or_pause",
          },
        ],
      },
      semicolon: {
        to: [
          {
            key_code: "fastforward",
          },
        ],
      },
      e: open(
        `raycast://extensions/thomas/elgato-key-light/toggle?launchType=background`
      ),
      // "D"o not disturb toggle
      d: open(
        `raycast://extensions/yakitrak/do-not-disturb/toggle?launchType=background`
      ),
      // "T"heme
      t: open(`raycast://extensions/raycast/system/toggle-system-appearance`),
      c: open("raycast://extensions/raycast/system/open-camera"),
      // 'v'oice
      v: {
        to: [
          {
            key_code: "spacebar",
            modifiers: ["left_option"],
          },
        ],
      },
    },

    // v = "moVe" which isn't "m" because we want it to be on the left hand
    // so that hjkl work like they do in vim
    v: {
      h: {
        to: [{ key_code: "left_arrow" }],
      },
      j: {
        to: [{ key_code: "down_arrow" }],
      },
      k: {
        to: [{ key_code: "up_arrow" }],
      },
      l: {
        to: [{ key_code: "right_arrow" }],
      },
      // Magicmove via homerow.app
      m: {
        to: [
          {
            key_code: "f",
            modifiers: ["right_control"],
          },
        ],
        // TODO: Trigger Vim Easymotion when VSCode is focused
      },
      // Scroll mode via homerow.app
      s: {
        to: [
          {
            key_code: "j",
            modifiers: ["right_control"],
          },
        ],
      },
      d: {
        to: [
          {
            key_code: "d",
            modifiers: ["right_shift", "right_command"],
          },
        ],
      },
      u: {
        to: [{ key_code: "page_down" }],
      },
      i: {
        to: [{ key_code: "page_up" }],
      },
    },

    // r = "Raycast"
    r: {
      c: open("raycast://extensions/thomas/color-picker/pick-color"),
      n: open("raycast://script-commands/dismiss-notifications"),
      l: open(
        "raycast://extensions/stellate/mxstbr-commands/create-mxs-is-shortlink"
      ),
      e: open(
        "raycast://extensions/raycast/emoji-symbols/search-emoji-symbols"
      ),
      p: open("raycast://extensions/raycast/raycast/confetti"),
      a: open("raycast://extensions/raycast/raycast-ai/ai-chat"),
      s: open("raycast://extensions/peduarte/silent-mention/index"),
      h: open(
        "raycast://extensions/raycast/clipboard-history/clipboard-history"
      ),
      1: open(
        "raycast://extensions/VladCuciureanu/toothpick/connect-favorite-device-1"
      ),
      2: open(
        "raycast://extensions/VladCuciureanu/toothpick/connect-favorite-device-2"
      ),
    },
  }),

  // Add this new rule for number row symbol swap
  // {
  //   description: "Exchange numbers and symbols (1234567890 and !@#$%^&*())",
  //   manipulators: [
  //     // Numbers to symbols (unshifted to shifted)
  //     ...["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"].map(
  //       (num): Manipulator => ({
  //         type: "basic",
  //         from: {
  //           key_code: num as KeyCode,
  //           modifiers: {
  //             optional: ["caps_lock"],
  //           },
  //         },
  //         to: [
  //           {
  //             key_code: num as KeyCode,
  //             modifiers: ["left_shift"],
  //           },
  //         ],
  //       })
  //     ),
  //     // Special keys to their shifted versions
  //     {
  //       type: "basic",
  //       from: {
  //         key_code: "open_bracket",
  //         modifiers: {
  //           optional: ["caps_lock"],
  //         },
  //       },
  //       to: [
  //         {
  //           key_code: "open_bracket",
  //           modifiers: ["left_shift"],
  //         },
  //       ],
  //     },
  //     {
  //       type: "basic",
  //       from: {
  //         key_code: "close_bracket",
  //         modifiers: {
  //           optional: ["caps_lock"],
  //         },
  //       },
  //       to: [
  //         {
  //           key_code: "close_bracket",
  //           modifiers: ["left_shift"],
  //         },
  //       ],
  //     },
  //     {
  //       type: "basic",
  //       from: {
  //         key_code: "semicolon",
  //         modifiers: {
  //           optional: ["caps_lock"],
  //         },
  //       },
  //       to: [
  //         {
  //           key_code: "semicolon",
  //           modifiers: ["left_shift"],
  //         },
  //       ],
  //     },
  //     // Quote key remapping
  //     {
  //       type: "basic",
  //       from: {
  //         key_code: "quote",
  //         modifiers: {
  //           optional: ["caps_lock"],
  //         },
  //       },
  //       to: [
  //         {
  //           key_code: "quote",
  //           modifiers: ["left_shift"],
  //         },
  //       ],
  //     },
  //     // Symbols to numbers (shifted to unshifted)
  //     ...["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"].map(
  //       (num): Manipulator => ({
  //         type: "basic",
  //         from: {
  //           key_code: num as KeyCode,
  //           modifiers: {
  //             mandatory: ["shift"],
  //             optional: ["caps_lock"],
  //           },
  //         },
  //         to: [
  //           {
  //             key_code: num as KeyCode,
  //           },
  //         ],
  //       })
  //     ),
  //     // Special keys from shifted to unshifted
  //     {
  //       type: "basic",
  //       from: {
  //         key_code: "open_bracket",
  //         modifiers: {
  //           mandatory: ["shift"],
  //           optional: ["caps_lock"],
  //         },
  //       },
  //       to: [
  //         {
  //           key_code: "open_bracket",
  //         },
  //       ],
  //     },
  //     {
  //       type: "basic",
  //       from: {
  //         key_code: "close_bracket",
  //         modifiers: {
  //           mandatory: ["shift"],
  //           optional: ["caps_lock"],
  //         },
  //       },
  //       to: [
  //         {
  //           key_code: "close_bracket",
  //         },
  //       ],
  //     },
  //     {
  //       type: "basic",
  //       from: {
  //         key_code: "semicolon",
  //         modifiers: {
  //           mandatory: ["shift"],
  //           optional: ["caps_lock"],
  //         },
  //       },
  //       to: [
  //         {
  //           key_code: "semicolon",
  //         },
  //       ],
  //     },
  //     // Quote key from shifted to unshifted
  //     {
  //       type: "basic",
  //       from: {
  //         key_code: "quote",
  //         modifiers: {
  //           mandatory: ["shift"],
  //           optional: ["caps_lock"],
  //         },
  //       },
  //       to: [
  //         {
  //           key_code: "quote",
  //         },
  //       ],
  //     },
  //   ],
  // },
];

fs.writeFileSync(
  "karabiner.json",
  JSON.stringify(
    {
      global: {
        show_in_menu_bar: false,
      },
      profiles: [
        {
          name: "Default",
          complex_modifications: {
            rules,
          },
        },
      ],
    },
    null,
    2
  )
);
