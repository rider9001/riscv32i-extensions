simvision {

    # Open new waveform window
    window new WaveWindow  -name  "Waves for RSICV32I program counter"
    waveform  using  "Waves for RSICV32I program counter"

    waveform  add -signals  pcR32I_stim.clock

    set id [ waveform  add  -signals  pcR32I_stim.PCBranchType ]
    waveform format $id -radix %d

    waveform  add -signals  pcR32I_stim.TestBranch
    waveform  add -signals  pcR32I_stim.AlwaysBranch
    waveform  add -signals  pcR32I_stim.AbsoluteBranch
    waveform  add -signals  pcR32I_stim.EQ
    waveform  add -signals  pcR32I_stim.NE
    waveform  add -signals  pcR32I_stim.LT
    waveform  add -signals  pcR32I_stim.LTU
    waveform  add -signals  pcR32I_stim.GE
    waveform  add -signals  pcR32I_stim.GEU

    set id [ waveform  add  -signals  pcR32I_stim.BranchAddr ]
    waveform format $id -radix %d

    set id [ waveform  add  -signals  pcR32I_stim.ProgAddr ]
    waveform format $id -radix %d
}

#set id [ waveform  add  -signals  control_state_stim.cntrl.Y_real ]
#    waveform format $id -radix %h