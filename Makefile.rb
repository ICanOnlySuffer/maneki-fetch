
CONFIG = {
	'ASCII_FILE' => '',
	'ASCII_COLOR' => '',
	'SPECIAL_COLOR' => '',
	'CLEAR_COLOR' => '',
	'KEY_COLOR' => '',
	'VALUE_COLOR' => '',
	'LINE_0' => '',
	'LINE_1' => '',
	'LINE_2' => '',
	'LINE_3' => '',
	'LINE_4' => '',
	'LINE_5' => ''
}

ARGV.each do |argv|
	key, value = argv.split '=', 2
	CONFIG[key] = value
end

def column key, value
	"#{CONFIG['KEY_COLOR']}#{key} #{CONFIG['VALUE_COLOR']}`#{value}`"
end

ASCII_LINES = (
	File.read CONFIG['ASCII_FILE'] rescue <<~TXT
		   /_____\\
		    /, ,\\
		    )<> (
		   / / | \\
		__/\\|  /__\\
		\\_/----\\_/
	TXT
).split ?\n
INFO_LINES = 6.times.map do |i|
end

File.open 'bin/psf', ?w do |file|
	file.write <<~TXT
	#!/bin/env sh
	
	echo -en "\\
	#{
		ASCII_LINES.map.with_index do |ascii_line, i|
			length = ascii_line.length
			ascii_line.gsub! ?\\, '\\\\\\\\\\\\\\'
			spacing = 12 - length + ascii_line.length
			
			info_line = case CONFIG["LINE_#{i}"]
			when 'user_at_host'
				"#{CONFIG['SPECIAL_COLOR']}$USER@`uname -n`"
			when 'kernel'
				column 'krl', 'uname -r'
			when 'host'
				column 'hst',
					'cat /sys/devices/virtual/dmi/id/product_name'
			when 'uptime'
				column 'upt', "uptime -p | cut -d' ' -f2-"
			when 'memory'
				column 'mem',
					"free -m | awk 'NR==2{print $3\"M / \"$2\"M\"}'"
			else
				''
			end
			
			sprintf "%s%-#{spacing}s%s\n",
				CONFIG['ASCII_COLOR'],
				ascii_line,
				info_line
		end.join
	}#{CONFIG['CLEAR_COLOR']}"
	
	TXT
end

