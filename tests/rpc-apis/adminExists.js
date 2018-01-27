function adminExists() {
    try {
        admin
    } catch (e) {
        return false
    }

    return true
}
