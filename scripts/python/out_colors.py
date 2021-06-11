
class OutColors:
      def __init__(self):
         self.colors = {}
         self.colors["black"] = {"fg": 30, "bg": 40, "fg_high": 90, "bg_high": 100}
         self.colors["red"] = {"fg": 31, "bg": 41, "fg_high": 91, "bg_high": 101}
         self.colors["green"] = {"fg": 32, "bg": 42, "fg_high": 92, "bg_high": 102}
         self.colors["yellow"] = {"fg": 33, "bg": 43, "fg_high": 93, "bg_high": 103}
         self.colors["blue"] = {"fg": 34, "bg": 44, "fg_high": 94, "bg_high": 104}
         self.colors["magenta"] = {"fg": 35, "bg": 45, "fg_high": 95, "bg_high": 105}
         self.colors["cyan"] = {"fg": 36, "bg": 46, "fg_high": 96, "bg_high": 106}
         self.colors["white"] = {"fg": 37, "bg": 47, "fg_high": 97, "bg_high": 107}

         self.nocolor = 0
         self.bold = 1
         self.light = 1
         self.underline = 4
         self.escape = "\x1b["
         self.prefix_256 = "38;5;"

      def get_fg_color(self, color_name, light = 0):
            color_dict = self.colors[color_name]
            color_val = self.escape + str(light) + ";" + str(color_dict["fg"]) + "m"
            return color_val

      def get_fg_high_color(self, color_name):
            color_dict = self.colors[color_name]
            color_val = self.escape + str(color_dict["fg_high"]) + "m"
            return color_val

      def get_fg_color_256(self, color_num = 0):
            if color_num < 0 or color_num > 255:
                  color_num = 0

            color_val = self.escape + self.prefix_256 + str(color_num) + "m"
            return color_val

      def get_bg_color(self, color_name, light = 0):
            color_dict = self.colors[color_name]
            color_val = self.escape + str(light) + ";" + str(color_dict["bg"]) + "m"
            return color_val

      def get_both_color(self, bg_color_name = "black", fg_color_name = "white", bg_light = 0, fg_light = 0):
            bg_color_dict = self.colors[bg_color_name]
            fg_color_dict = self.colors[fg_color_name]
            color_val = self.escape + str(fg_color_dict["fg"]) + ";" + str(bg_color_dict["bg"]) + "m"
            return color_val
      
      def get_no_color(self):
            color_val = self.escape + str(self.nocolor) + "m"
            return color_val

      def show_256_colors(self):
            lc = 0
            for code in range(0, 255):
                  color_val = self.escape + self.prefix_256 + str(code) + "m"
                  color_disp = "x1b[" + self.prefix_256 + str(code) + "m"
                  print(f"{color_val}{color_disp}", end='')
                  lc += 1
                  if lc % 4 == 0:
                        print("")

