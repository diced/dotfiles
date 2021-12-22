function monitor_neighbor_index(which, direction) {
    const neighbor = global.display.get_monitor_neighbor_index(which, direction);
    return neighbor < 0 ? null : neighbor;
}
