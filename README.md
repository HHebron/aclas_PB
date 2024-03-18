# aCLAS

This project contains data and scripts for the paper:

**A closed-loop auditory stimulation approach selectively modulates alpha oscillations and sleep onset dynamics in humans**

Data to produce figures 1-6 is contained in \Data

Outlined below is the organisation of the data structure for each figure

**Figure 1**

_clusters_  
The channel numbers for the clusters of interest in experiment 1 and 2  
[experiment x channel]

_num_participants_  
number of participants for experiments 1 and 2

_ISI_   
The average inter-stimulus interval for each participant in experiments 1 and 2

_power_off_     
The average power spectrum, taken from the phase-locking electrode, for each participants in experiments 1 and 2    
[participant x frequency]

_ecHT_angle_    
The average phase angle (radians) at stimulus onset for each participant and condition in experiments 1 and 2. Taken from the phase-locking electrode 
[participant x condition]

_fz_angle_  
The average phase angle (radians) at stimulus onset for each high-density EEG channel, participant, and condition in experiments 1 and 2. Taken from the high-density EEG net
[channel x participant x condition]

_fz_R_  
The resultant of stimulus onset phases for each high-density EEG channel, participant, and condition in experiments 1 and 2. Taken from the high-density EEG net
[channel x participant x condition]

_ecHT_R_    
The resultant of stimulus onset phases for each participant, and condition in experiments 1 and 2. Taken from the phase-locking electrode
[participant x condition]

_frequency_off_     
The average instantaneous alpha frequency (Hz) taken from the 'off' periods for each participant, for experiments 1 and 2. Taken from the phase-locking electrode.

_f_     
The frequencies to which the aforementioned power spectra correspond

_layout_    
High density EEG channel layout for topoplots

_neighbours_
High density EEG channel _neighbours_                       


**Figure 2**

_f_     
The frequencies to which the power spectra correspond

_frequency_change_  
The frequency change (Hz) from 'off' to 'on' periods (i.e., stimulus induced changes) for each channel, participant, and condition for experiments 1 and 2
[channel x participant x condition]

_num_participants_  
participant numbers for experiments 1 and 2

_cluster_power_change_  
The change in power (relative to 'off' periods, log ratio)for each condition, frequency, second of stimulation, and participant. Values averaged over channels in clusters of interest for experiments 1 and 2.

_average_power_change_  
The average change in power (9.8-10.2 Hz) (relative to 'off' periods, log ratio) for each channel, condition, frequency, and participant. Values averaged over the stimulation period, for experiments 1 and 2.

_cluster_spectrum_
The average change in power (relative to 'off' periods, log ratio) for each condition, frequency, and participant. Values averaged over channels in clusters of interest, and across the stimulation period, for experiments 1 and 2.

**Figure 3**_

_ERP_   
Broadband ERP amplitudes for each participant, timepoint, and condition, in experiments 3 and 4. Taken from high-density EEG channel of interest in each experiment, Fz and Pz respectively. Timepoints are -1 second to +1 second, sampling rate is 500 Hz.
[participant x time x condition]

_ecHT_real_ 
Alpha band ERP amplitudes for each participant, timepoint, and condition, in experiments 3 and 4. Taken from high-density EEG channel of interest in each experiment, Fz and Pz respectively. Timepoints are -1 second to +1 second, sampling rate is 500 Hz.
[participant x time x condition]

_ecHT_phase_    
Alpha band phase for each participant, timepoint, and condition, in experiments 3 and 4. Taken from high-density EEG channel of interest in each experiment, Fz and Pz respectively. Timepoints are -1 second to +1 second, sampling rate is 500 Hz.
[participant x time x condition]

_ecHT_r_    
Alpha band phase resultant for each participant, timepoint, and condition, in experiments 3 and 4. Taken from high-density EEG channel of interest in each experiment, Fz and Pz respectively. Timepoints are -1 second to +1 second, sampling rate is 500 Hz.
[participant x time x condition]

_octile_z_  
Maximum z-scores (i.e., measure of non-uniformity) evoked by stimuli in 8 octiles of alpha power, going from low to high. For experiments 3 and 4.
[octile x experiment]

_num_participants_  
Participant numbers for experiments 3 and 4.


**Figure 4**

_phase_after_   
Alpha band phase (radians) for each participant, timepoint (0-1004 ms), and phase bin, in experiments 3 and 4. Taken from high-density EEG channel of interest in each experiment, Fz and Pz respectively. Sampling rate is 500 Hz. Phase bins are 36 degrees in width, starting at 0 and proceeding around the circle.
[participant x time x phase bin]    

_phase_change_  
Same as above, but for difference between actual phase and expected phase, assuming a 10 Hz oscillation.

_R_after_   
Same as above, but for phase resultant.

_num_participants_  
Participant numbers for experiments 3 and 4.

**Figure 5**    

_power_     
The change in power (relative to 'off' periods, log ratio)for each stimulation condition (conditions are pre-peak stimulation, pre-trough stimulation) , frequency, second of the nap (up to 30.6 minutes), and participant for the Fz channel for experiment 5. Frequencies are 2:.1:30 Hz.
[frequency x second x participant]

_frequency_line_       
Instantaneous alpha frequency at Fz for each stimulation condition (conditions are pre-peak stimulation, pre-trough stimulation) in 10-second bins across the nap. Data are sham-subtracted.
[participant x time bin x condition]

_frequency_violins_       
Instantaneous alpha frequency at Fz for each stimulation condition (conditions are pre-peak stimulation, pre-trough stimulation) averaged across two periods of the nap (stimulation and post-stimulation, respectively). Data are sham-subtracted.
[participant x condition x period]

**Figure 6**

The data are contained herein are for plotting either line plots or violin plots of various sleep staging and EEG features for experiment 5

The line plots are organised as follows: [condition x 30-second time bin x feature], (conditions are pre-peak stimulation, pre-trough stimulation, sham) and correspond to the following features:  
(1) Number of participants in any sleep stage (i.e., not wake) (%)  
(2) Average sleep stage (i.e., wake is assigned 0 and N1-N3 are assigned 1-3). Averaged over participants.  
(3) Cumulative sum of minutes of N2+ sleep (i,e., epochs scored as N2 or N3), averaged over participants    
(4) Participants having had at least 30 seconds of sleep (any stage) (%)    
(5) Participants having had at least 120 seconds of sleep (any stage) (%)   
(6) Participants having had at least 30 seconds of sleep (N2 and greater) (%)    
(7) Participants having had at least 120 seconds of sleep (N2 and greater) (%)      
(8) Abundance of alpha oscillations, averaged over frontal channels (F3 and F4) 
(9) Abundance of sigma oscillations, averaged over frontal channels (F3 and F4)
(10) Offset of aperiodic component of power spectrum, averaged over frontal channels (F3 and F4)
(11) Exponent of aperiodic component of power spectrum, averaged over frontal channels (F3 and F4). More negative values indicate a steeper slope.

The violin plot data are organised as follows: [participant x condition x feature], (conditions are pre-peak stimulation, pre-trough stimulation, sham) and correspond to the following features:  
(1) Number of epochs of any sleep stage (i.e., not wake) during stimulation period. 
(2) Number of epochs of any sleep stage (i.e., not wake) during post-stimulation period. 
(3) Average sleep stage (i.e., wake is assigned 0 and N1-N3 are assigned 1-3) for stimulation period. 
(4) Average sleep stage (i.e., wake is assigned 0 and N1-N3 are assigned 1-3) for post-stimulation period. 
(5) Number of epochs of N2+ sleep (i,e., epochs scored as N2 or N3) for stimulation perod.
(6) Number of epochs of N2+ sleep (i,e., epochs scored as N2 or N3) for post-stimulation perod.
(7) Latency to begining of first 30 seconds of sleep (any stage). Data are log-transformed minutes
(8) Latency to begining of first 120 seconds of sleep (any stage). Data are log-transformed minutes
(9) Latency to begining of first 30 seconds of sleep (N2 or greater). Data are log-transformed minutes
(10) Latency to begining of first 120 seconds of sleep (N2 or greater). Data are log-transformed minutes    
(11) Abundance of alpha oscillations, averaged over frontal channels (F3 and F4) and stimulation period
(12) Abundance of alpha oscillations, averaged over frontal channels (F3 and F4) and post-stimulation period
(13) Abundance of sigma oscillations, averaged over frontal channels (F3 and F4) and stimulation period
(14) Abundance of sigma oscillations, averaged over frontal channels (F3 and F4) and post-stimulation period
(15) Offset of aperiodic component of power spectrum, averaged over frontal channels (F3 and F4), averaged over stimulation period      
(16) Offset of aperiodic component of power spectrum, averaged over frontal channels (F3 and F4), averaged over post-stimulation period  
(17) Exponent of aperiodic component of power spectrum, averaged over frontal channels (F3 and F4), averaged over stimulation period      
(18) Exponent of aperiodic component of power spectrum, averaged over frontal channels (F3 and F4), averaged over post-stimulation period  

_line_plot_names_   
Labels for the y axis of line plots

_num_participants_  
participant numbers for experiment 5
