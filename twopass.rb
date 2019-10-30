# Universidade Estadual de Santa Cruz
# DCET - Ciência da Computação
# CET088 - Software Básico
# Brandon Antunes Neri Ribeiro - 201320040

load 'dictionary.rb'                                                                                                    # Import and load all the content in variables

def fillMacro(macro, i)                                                                                                 # Fill the macro dictionary
    while $lines[i] != '%endmacro' do                                                                                   # Read all macro definitions
        line = $lines[i].strip                                                                                          # Withdraw blank spaces
        if $macro_lines[macro].nil?                                                                                     # If it's the first line of the macro, initializes
            $macro_lines[macro] = []
        end
        if $instructions.include?(line.split[0])                                                                        # Put the array of macros in the hash 
            $macro_lines[macro] += [line]
        end
        i += 1
    end
    i                                                                                                                   # Return
end

def treats(mnem, operands, inst, macro_operands)                                                                        # Treats each line processed to the final code
    return if $passage == 1                                                                                             # Treats the line only at the second passage
    ilc = $ilc.to_s(16)
    opcode = mnem[:opcode]                                                                                              # Catch the opcode from the current mnemonico
    if $check_3rd_op.include?(inst)                                                                                     # Third operand
        if operands[0] == 'je'
            third = operands[1]
        else
            third = operands[2]
        end
        if $macro_variables.include?(third)                                                                             # If the 3rd is %1, %2, it'll be replaced by the operator from the original call
            third = macro_operands[third[1].to_i].split(',')[0]
        end
        third = third.rjust(2, '0')                                                                                     # Padding 
        third = $constants[third.to_sym] || $variables[third.to_sym] || $labels[third.to_sym] || third[1].bytes[0]      # Verification
        third = third.to_s(16).rjust(2, '0')                                                                            # Padding
        opcode += third                                                                                                 # Plus the 3rd treated operand
    end
    res = ilc.to_s.rjust(6, '0') + ' ' + opcode.to_s.ljust(16, '0').scan(/.{4}/).join(' ')                              # Treatment result
    puts res                                                                                                            # Printing the final result from each line
    File.write("twopassBrandon.o", res + "\n", mode: "a")                                                                      # Creating file .o
end

def callMacro(macro_operands) # Process a macro call
    $macro_lines[macro_operands[0]].each do |line|                                                                      # For each line in the macro, do
        operands = line.split                                                                                           # Define operands to each line 
        if $instructions.include?(operands[0])                                                                          # Instruction?
            mnem = operands[0] == 'mov' ? "#{operands[0]} #{operands[1]}".split(',')[0] : operands[0]                   # If it's mov, takes the second operand as well
            $ilc += $mnems[mnem.to_sym][:size]                                                                          # Updates ILC
            treats($mnems[mnem.to_sym], operands, mnem, macro_operands)                                                 # Treating data to print
        elsif $macros.include?(operands[0])                                                                             # If it's a macro call
            if $macro_variables.include?(operands[1])                                                                   # If the 3rd is %1, %2, it'll be replaced by the operator from the original call
                operands[1] = macro_operands[operands[1][1].to_i]
            end
            if $macro_variables.include?(operands[2])
                operands[2] = macro_operands[operands[2][1].to_i]
            end
            callMacro(operands)                                                                                         # When a macro calls other macros
        end
    end
end
 
#File.write("passage.o", $header) # Creating the header

$lines = File.readlines('portaoBrandon.asm').map(&:chomp)                                                               # Creates the array of lines in the file

2.times do                                                                                                              # Makes the two-passage algorithm on the gate code
    $macro_lines = { }                                                                                                  # Clear the array dictionary containing each line of the macro 
    $passage += 1                                                                                                       # Define the current passage
    $ilc = 0                                                                                                            # Clear the ILC on each passage
    i = 0                                                                                                               # Loop control
    while i < $lines.size do                                                                                            # Reads every line in the file
        line = $lines[i]                                                                                                #
        line = line.strip                                                                                               # Clear blank spaces
        operands = line.split                                                                                           # Split the line with spaces
        if line[0] == ';'                                                                                               # Rules out comments
            i += 1
            next
        end 
        if $instructions.include?(operands[0])                                                                          # If it finds an instruction
            mnem = operands[0] == 'mov' ? "#{operands[0]} #{operands[1]}".split(',')[0] : operands[0]                   # If it's mov, takes the second operand as well
            if $mnems[mnem.to_sym]                                                                                      # ILC math
                $ilc += $mnems[mnem.to_sym][:size]
                treats($mnems[mnem.to_sym], operands, mnem, [])                                                         # Treats the read line
            else
                puts mnem
            end
        elsif operands[0] == '%macro'                                                                                   # Macro definition?
            i = fillMacro(operands[1], i + 1)                                                                           # Storing each macro line
        elsif $macros.include?(operands[0])                                                                             # Macro call?
            callMacro(operands)
        elsif $passage == 1 && !operands.empty? && (operands[0][0] == '.' || operands[0][0] == '_')
            $labels[operands[0].to_sym] = $ilc.to_s(16)
        end

        i = i + 1
    end
end

#File.write("passage.o", $footer, mode: "a")