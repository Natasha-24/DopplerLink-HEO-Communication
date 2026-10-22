# DopplerLink: Impact of Time-Varying Doppler on Digital Communication in Highly Elliptical Orbits

## 1. Project Overview

**DopplerLink** is a MATLAB-based simulation project that studies the impact of time-varying Doppler shift on digital communication in Highly Elliptical Orbits (HEO).

Satellite motion relative to a ground receiver causes a Doppler shift in the received carrier frequency. Since the relative radial velocity changes throughout the orbit, the Doppler shift also varies with time. This frequency variation can affect the received BPSK signal and significantly degrade communication performance.

This project models HEO satellite motion, calculates the corresponding Doppler characteristics, simulates BPSK communication, and evaluates the effect of Doppler compensation using Bit Error Rate (BER).

## 2. Project Objectives

- Model satellite motion in a Highly Elliptical Orbit.
- Calculate the satellite-to-receiver range and range rate.
- Analyse time-varying Doppler shift and Doppler rate.
- Simulate BPSK communication under Additive White Gaussian Noise (AWGN).
- Compare communication performance with and without Doppler effects.
- Implement ideal, model-informed Doppler compensation.
- Evaluate BER for different \(E_b/N_0\) values.
- Study the effect of carrier frequency and Doppler-estimation errors.
- Compare communication performance across different orbital regions.

## 3. Tools and Technologies

- **MATLAB** — orbital modelling, communication simulation, calculations and visualisation.
- **BPSK** — digital modulation scheme used for the communication link.
- **AWGN channel model** — used to represent additive noise.
- **BER analysis** — used to measure communication performance.

## 4. System Model

The simulation uses a Highly Elliptical Orbit with the following orbital parameters:

- Earth radius: 6,378 km
- Perigee altitude: 1,000 km
- Apogee altitude: 39,000 km

The communication link uses BPSK modulation. The received signal is analysed under baseline, Doppler-affected and Doppler-compensated conditions.

The simulation also examines carrier frequencies of 900 MHz, 2 GHz and 5 GHz.

## 5. Implementation Phases

### Phase 1 — HEO Orbital Modelling

- Model the satellite orbit using the selected orbital parameters.
- Calculate satellite position and velocity.
- Determine range and range rate relative to the receiver.
- Calculate Doppler shift and Doppler rate.

### Phase 2 — BPSK Communication Baseline

- Establish baseline BPSK communication performance in AWGN.
- Calculate BER to provide a reference for comparison with Doppler-affected communication.

### Phase 3 — Time-Varying Doppler Effect

- Introduce the time-varying Doppler effect derived from the orbital model.
- Simulate its impact on the BPSK communication link.
- Compare BER with the baseline result.

### Phase 4 — Doppler Compensation

- Apply ideal, model-informed Doppler compensation.
- Compare communication performance before and after compensation.
- Evaluate the extent to which compensation restores the baseline performance.

### Phase 5 — BER Performance Analysis

- Evaluate BER at different \(E_b/N_0\) values.
- Compare baseline, uncompensated and compensated communication.
- Examine how noise and Doppler affect the received data.

### Phase 6 — Carrier-Frequency Analysis

- Analyse carrier frequencies of 900 MHz, 2 GHz and 5 GHz.
- Compare maximum Doppler shift and Doppler rate.
- Evaluate BER with and without compensation at different carrier frequencies.

### Phase 7 — Doppler-Estimation Error Analysis

- Introduce different levels of Doppler-estimation error.
- Evaluate the impact of estimation errors on compensation.
- Compare BER for different error percentages.

### Phase 8 — Orbital-Region Analysis

- Divide the simulated orbit into ten regions.
- Compare range rate, maximum Doppler shift and Doppler rate across the regions.
- Evaluate BER before and after compensation.
- Examine how changing satellite-receiver geometry affects the communication link.

## 6. Simulation Results

### 6.1 Baseline and Doppler-Affected Communication

For a simulation with 5,000 transmitted bits and \(E_b/N_0=8\) dB:

- **Baseline BPSK BER:** 0
- **BPSK BER with HEO Doppler:** 0.486600
- **BPSK BER after ideal Doppler compensation:** 0

The uncompensated BER is close to 0.5, indicating that the receiver performs poorly when the simulated time-varying Doppler effect is present. Ideal compensation restores the BER to zero for this particular simulation run.

A measured BER of zero means that no bit errors occurred in the simulated bit sequence; it does not guarantee error-free communication in every transmission.

### 6.2 BER Versus \(E_b/N_0\)

The project evaluates BER at \(E_b/N_0\) values of 0, 2, 4, 6, 8, 10 and 12 dB.

The simulation shows that:

- Baseline BPSK BER generally decreases as \(E_b/N_0\) increases.
- The uncompensated Doppler case remains close to a BER of 0.5 across the tested values.
- The compensated case approaches the baseline performance.

These results demonstrate that increasing the signal-to-noise ratio alone does not resolve the simulated Doppler-induced degradation.

### 6.3 Carrier-Frequency Analysis

The following maximum Doppler shift and Doppler-rate values were obtained from the simulation:

**At 900 MHz**
- Maximum Doppler shift: 25.71 kHz
- Maximum Doppler rate: 250.60 Hz/s
- BER without compensation: 0.492360
- BER with compensation: 0.000220

**At 2 GHz**
- Maximum Doppler shift: 57.14 kHz
- Maximum Doppler rate: 556.89 Hz/s
- BER without compensation: 0.502380
- BER with compensation: 0.000180

**At 5 GHz**
- Maximum Doppler shift: 142.86 kHz
- Maximum Doppler rate: 1,392.23 Hz/s
- BER without compensation: 0.499280
- BER with compensation: 0.000200

The results show that the Doppler shift and Doppler rate increase with carrier frequency. Compensation substantially improves BER in the simulated cases.

### 6.4 Doppler-Estimation Error Analysis

At a carrier frequency of 2 GHz and \(E_b/N_0=8\) dB, the simulation produced the following BER values:

- **0% estimation error:** 0.000200
- **1% estimation error:** 0.495680
- **2% estimation error:** 0.501040
- **5% estimation error:** 0.500760
- **10% estimation error:** 0.496320
- **20% estimation error:** 0.500420

The results indicate that the simulated compensation is highly sensitive to Doppler-estimation error. Even a small mismatch can substantially degrade BER in this implementation.

This sensitivity is a result of the compensation and signal model used in the simulation; it should not be interpreted as a universal performance limit for all practical Doppler-tracking systems.

### 6.5 Orbital-Region Analysis

The orbit is divided into ten regions to examine changes in satellite-receiver geometry.

The simulation results show that:

- Range rate changes across the orbit.
- Doppler shift and Doppler rate vary with orbital position.
- Uncompensated BER remains approximately 0.49–0.51 across the tested regions.
- Compensated BER is approximately 0–0.0005 across the tested regions.

This analysis demonstrates the importance of considering time-varying orbital geometry when studying satellite communication performance.

## 7. Key Findings

- Satellite motion causes Doppler shift when there is relative radial velocity between the satellite and receiver.
- The Doppler shift varies with the satellite's relative geometry and range rate.
- Higher carrier frequencies produce larger Doppler shifts for the same radial velocity.
- In the simulated conditions, uncompensated Doppler causes substantial degradation in BPSK detection.
- Ideal, model-informed compensation significantly improves the simulated BER.
- Doppler-estimation errors can strongly affect compensation performance.
- BER analysis across orbital regions helps illustrate the relationship between satellite motion and communication reliability.


## 8. Conclusion

DopplerLink investigates how time-varying Doppler shift affects BPSK digital communication in a Highly Elliptical Orbit. The MATLAB simulation combines orbital modelling, Doppler calculations, AWGN-based communication, BER analysis and ideal Doppler compensation.

The results show substantial degradation in the uncompensated communication link and significant improvement when the simulated Doppler effect is compensated. The carrier-frequency and estimation-error studies further demonstrate the importance of accurate Doppler modelling and compensation.

Overall, the project provides a simulation-based study of the relationship between HEO satellite motion and digital communication performance.

---
