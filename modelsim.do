# =====================================================
# Adaptive Access-Aware Register File
# ModelSim Simulation Script
# =====================================================

transcript on

# Clean previous compilation
if {[file exists work]} {
    vdel -all
}

vlib work
vmap work work

echo ""
echo "======================================="
echo " Compiling RTL Files"
echo "======================================="

vlog rtl/clock_gating.v
vlog rtl/bank_access_generator.v
vlog rtl/access_monitor_v2.v
vlog rtl/banked_rf.v
vlog rtl/access_aware_rf_top.v

echo ""
echo "======================================="
echo " Compiling Testbench"
echo "======================================="

vlog tb/tb_access_aware_rf_top.v

echo ""
echo "======================================="
echo " Starting Simulation"
echo "======================================="

vsim -voptargs=+acc work.tb_access_aware_rf_top

add wave -r *

run -all

echo ""
echo "======================================="
echo " Simulation Completed"
echo "======================================="