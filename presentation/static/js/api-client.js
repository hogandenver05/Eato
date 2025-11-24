// API Client for Eato Meal Tracker
const API_BASE_URL = 'http://localhost:8000/api';
const TOKEN_KEY = 'eato_token';

// API Client Class
class EatoAPIClient {
    constructor() {
        this.token = localStorage.getItem(TOKEN_KEY) || null;
    }

    // Get authorization headers
    getHeaders(includeAuth = true) {
        const headers = {
            'Content-Type': 'application/json',
            'Accept': 'application/json'
        };
        if (includeAuth && this.token) {
            headers['Authorization'] = `Bearer ${this.token}`;
        }
        return headers;
    }

    // Make API request
    async request(endpoint, options = {}) {
        const url = `${API_BASE_URL}${endpoint}`;
        const config = {
            ...options,
            headers: {
                ...this.getHeaders(options.requireAuth !== false),
                ...options.headers
            }
        };

        try {
            const response = await fetch(url, config);
            const data = await response.json();
            
            if (!response.ok) {
                // Log error details for debugging
                console.error('API Error:', { url, status: response.status, data });
                throw new Error(data.message || `HTTP ${response.status}: ${response.statusText}`);
            }
            
            return { success: true, data };
        } catch (error) {
            console.error('Request failed:', { url, error: error.message });
            return { success: false, error: error.message };
        }
    }

    // Authentication methods
    async register(username, password) {
        const result = await this.request('/register', {
            method: 'POST',
            body: JSON.stringify({ username, password }),
            requireAuth: false
        });
        return result;
    }

    async login(username, password) {
        const result = await this.request('/login', {
            method: 'POST',
            body: JSON.stringify({ username, password }),
            requireAuth: false
        });
        
        if (result.success && result.data.token) {
            this.token = result.data.token;
            localStorage.setItem(TOKEN_KEY, this.token);
        }
        
        return result;
    }

    async logout() {
        const result = await this.request('/logout', {
            method: 'POST'
        });
        
        if (result.success) {
            this.token = null;
            localStorage.removeItem(TOKEN_KEY);
        }
        
        return result;
    }

    // Food methods
    async getFoods() {
        return await this.request('/foods', { method: 'GET' });
    }

    async getFood(id) {
        return await this.request(`/foods/${id}`, { method: 'GET' });
    }

    async createFood(foodName, calories) {
        return await this.request('/foods', {
            method: 'POST',
            body: JSON.stringify({ food_name: foodName, calories: parseInt(calories) })
        });
    }

    async updateFood(id, foodName, calories) {
        return await this.request(`/foods/${id}`, {
            method: 'PUT',
            body: JSON.stringify({ food_name: foodName, calories: parseInt(calories) })
        });
    }

    async deleteFood(id) {
        return await this.request(`/foods/${id}`, { method: 'DELETE' });
    }

    // Favorite methods
    async getFavorites() {
        return await this.request('/favorites', { method: 'GET' });
    }

    async addFavorite(foodId) {
        return await this.request('/favorites', {
            method: 'POST',
            body: JSON.stringify({ food_id: parseInt(foodId) })
        });
    }

    async removeFavorite(favoriteId) {
        return await this.request(`/favorites/${favoriteId}`, { method: 'DELETE' });
    }

    isAuthenticated() {
        return this.token !== null;
    }
}

// UI Controller
class EatoAPIClientUI {
    constructor() {
        this.client = new EatoAPIClient();
        this.currentFoods = [];
        this.currentFavorites = [];
        this.editingFoodId = null;
    }

    init() {
        this.render();
        this.loadFoods();
        this.loadFavorites();
    }

    render() {
        const app = document.getElementById('api-client-app');
        if (!app) return;

        app.innerHTML = `
            <div class="api-client-container">
                <!-- Authentication Section -->
                <section class="api-section auth-section">
                    <h2>Authentication</h2>
                    <div id="auth-status" class="auth-status"></div>
                    <div class="auth-forms">
                        <div class="auth-form">
                            <h3>Register</h3>
                            <form id="register-form">
                                <input type="text" id="register-username" placeholder="Username" required>
                                <input type="password" id="register-password" placeholder="Password (min 6 chars)" required>
                                <button type="submit">Register</button>
                            </form>
                        </div>
                        <div class="auth-form">
                            <h3>Login</h3>
                            <form id="login-form">
                                <input type="text" id="login-username" placeholder="Username" required>
                                <input type="password" id="login-password" placeholder="Password" required>
                                <button type="submit">Login</button>
                            </form>
                        </div>
                    </div>                    <div class="logout-container">
                    <button id="logout-btn" class="logout-btn" style="display: none;">Logout</button>

                </section>

                <!-- Foods Section -->
                <section class="api-section foods-section">
                    <h2>Foods Management</h2>
                    <div class="food-form-container">
                        <h3 id="food-form-title">Add New Food</h3>
                        <form id="food-form">
                            <input type="text" id="food-name" placeholder="Food Name" required>
                            <input type="number" id="food-calories" placeholder="Calories" required>
                            <div class="form-buttons">
                                <button type="submit" id="food-submit-btn">Add Food</button>
                                <button type="button" id="food-cancel-btn" style="display: none;">Cancel</button>
                            </div>
                        </form>
                    </div>
                    <div id="foods-list" class="foods-list"></div>
                </section>

                <!-- Favorites Section -->
                <section class="api-section favorites-section">
                    <h2>Favorites Management</h2>
                    <div class="favorite-form-container">
                        <h3>Add to Favorites</h3>
                        <form id="favorite-form">
                            <select id="favorite-food-id" required>
                                <option value="">Select a food...</option>
                            </select>
                            <button type="submit">Add to Favorites</button>
                        </form>
                    </div>
                    <div id="favorites-list" class="favorites-list"></div>
                </section>

                <!-- Response Display -->
                <section class="api-section response-section">
                    <h2>API Response</h2>
                    <div id="response-display" class="response-display"></div>
                </section>
            </div>
        `;

        this.attachEventListeners();
        this.updateAuthStatus();
    }

    attachEventListeners() {
        // Authentication
        document.getElementById('register-form').addEventListener('submit', (e) => {
            e.preventDefault();
            this.handleRegister();
        });

        document.getElementById('login-form').addEventListener('submit', (e) => {
            e.preventDefault();
            this.handleLogin();
        });

        document.getElementById('logout-btn').addEventListener('click', () => {
            this.handleLogout();
        });

        // Foods
        document.getElementById('food-form').addEventListener('submit', (e) => {
            e.preventDefault();
            if (this.editingFoodId) {
                this.handleUpdateFood();
            } else {
                this.handleCreateFood();
            }
        });

        document.getElementById('food-cancel-btn').addEventListener('click', () => {
            this.cancelEditFood();
        });

        // Favorites
        document.getElementById('favorite-form').addEventListener('submit', (e) => {
            e.preventDefault();
            this.handleAddFavorite();
        });
    }

    updateAuthStatus() {
        const statusDiv = document.getElementById('auth-status');
        const logoutBtn = document.getElementById('logout-btn');
        
        if (this.client.isAuthenticated()) {
            statusDiv.innerHTML = '<span class="status-success">✓ Authenticated</span>';
            logoutBtn.style.display = 'block';
        } else {
            statusDiv.innerHTML = '<span class="status-error">✗ Not authenticated</span>';
            logoutBtn.style.display = 'none';
        }
    }

    showResponse(result, isError = false) {
        const responseDiv = document.getElementById('response-display');
        const className = isError ? 'response-error' : 'response-success';
        const content = isError 
            ? `<pre class="${className}">Error: ${result.error || result.message || 'Unknown error'}</pre>`
            : `<pre class="${className}">${JSON.stringify(result.data || result, null, 2)}</pre>`;
        
        responseDiv.innerHTML = content;
        responseDiv.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
    }

    async handleRegister() {
        const username = document.getElementById('register-username').value;
        const password = document.getElementById('register-password').value;
        
        const result = await this.client.register(username, password);
        this.showResponse(result, !result.success);
        
        if (result.success) {
            document.getElementById('register-form').reset();
            this.showResponse({ data: { message: 'Registration successful! Please login.' } });
        }
    }

    async handleLogin() {
        const username = document.getElementById('login-username').value;
        const password = document.getElementById('login-password').value;
        
        const result = await this.client.login(username, password);
        this.showResponse(result, !result.success);
        
        if (result.success) {
            document.getElementById('login-form').reset();
            this.updateAuthStatus();
            await this.loadFoods();
            await this.loadFavorites();
        }
    }

    async handleLogout() {
        const result = await this.client.logout();
        this.showResponse(result, !result.success);
        
        if (result.success) {
            this.updateAuthStatus();
            this.currentFoods = [];
            this.currentFavorites = [];
            this.renderFoods();
            this.renderFavorites();
        }
    }

    async handleCreateFood() {
        const foodName = document.getElementById('food-name').value;
        const calories = document.getElementById('food-calories').value;
        
        const result = await this.client.createFood(foodName, calories);
        this.showResponse(result, !result.success);
        
        if (result.success) {
            document.getElementById('food-form').reset();
            await this.loadFoods();
        }
    }

    async handleUpdateFood() {
        const foodName = document.getElementById('food-name').value;
        const calories = document.getElementById('food-calories').value;
        
        const result = await this.client.updateFood(this.editingFoodId, foodName, calories);
        this.showResponse(result, !result.success);
        
        if (result.success) {
            this.cancelEditFood();
            await this.loadFoods();
        }
    }

    cancelEditFood() {
        this.editingFoodId = null;
        document.getElementById('food-form-title').textContent = 'Add New Food';
        document.getElementById('food-submit-btn').textContent = 'Add Food';
        document.getElementById('food-cancel-btn').style.display = 'none';
        document.getElementById('food-form').reset();
    }

    editFood(food) {
        this.editingFoodId = food.id;
        document.getElementById('food-name').value = food.food_name;
        document.getElementById('food-calories').value = food.calories;
        document.getElementById('food-form-title').textContent = 'Edit Food';
        document.getElementById('food-submit-btn').textContent = 'Update Food';
        document.getElementById('food-cancel-btn').style.display = 'inline-block';
        document.getElementById('food-form').scrollIntoView({ behavior: 'smooth', block: 'nearest' });
    }

    async deleteFood(id) {
        if (!confirm('Are you sure you want to delete this food?')) return;
        
        const result = await this.client.deleteFood(id);
        this.showResponse(result, !result.success);
        
        if (result.success) {
            await this.loadFoods();
            await this.loadFavorites();
        }
    }

    async loadFoods() {
        if (!this.client.isAuthenticated()) {
            this.renderFoods();
            return;
        }

        const result = await this.client.getFoods();
        if (result.success) {
            this.currentFoods = result.data;
        } else {
            this.currentFoods = [];
        }
        this.renderFoods();
    }

    // Helper function to format date (shared between renderFoods and renderFavorites)
    formatDate(dateString) {
        if (!dateString) return 'N/A';
        const date = new Date(dateString);
        return date.toLocaleString('en-US', {
            month: 'short',
            day: 'numeric',
            year: 'numeric',
            hour: 'numeric',
            minute: '2-digit',
            hour12: true
        });
    }

    renderFoods() {
        const foodsList = document.getElementById('foods-list');
        const favoriteSelect = document.getElementById('favorite-food-id');
        
        if (!this.client.isAuthenticated()) {
            foodsList.innerHTML = '<p class="info-message">Please login to view and manage foods.</p>';
            favoriteSelect.innerHTML = '<option value="">Please login first</option>';
            return;
        }

        if (this.currentFoods.length === 0) {
            foodsList.innerHTML = '<p class="info-message">No foods found. Add your first food above!</p>';
            favoriteSelect.innerHTML = '<option value="">No foods available</option>';
            return;
        }

        // Render foods list
        foodsList.innerHTML = `
            <table class="foods-table">
                <thead>
                    <tr>
                        <th>Food ID</th>
                        <th>Food Name</th>
                        <th>Calories</th>
                        <th>Last Updated</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    ${this.currentFoods.map(food => `
                        <tr>
                            <td>${food.id}</td>
                            <td>${food.food_name}</td>
                            <td>${food.calories}</td>
                            <td>${this.formatDate(food.updated_at)}</td>
                            <td class="actions">
                                <button class="btn-edit" data-food-id="${food.id}" data-food-name="${food.food_name.replace(/"/g, '&quot;')}" data-food-calories="${food.calories}">Edit</button>
                                <button class="btn-delete" data-food-id="${food.id}">Delete</button>
                            </td>
                        </tr>
                    `).join('')}
                </tbody>
            </table>
        `;

        // Attach event listeners to food action buttons
        foodsList.querySelectorAll('.btn-edit').forEach(btn => {
            btn.addEventListener('click', () => {
                const food = {
                    id: parseInt(btn.dataset.foodId),
                    food_name: btn.dataset.foodName.replace(/&quot;/g, '"'),
                    calories: parseInt(btn.dataset.foodCalories)
                };
                this.editFood(food);
            });
        });

        foodsList.querySelectorAll('.btn-delete').forEach(btn => {
            btn.addEventListener('click', () => {
                this.deleteFood(parseInt(btn.dataset.foodId));
            });
        });

        // Update favorite select dropdown
        favoriteSelect.innerHTML = '<option value="">Select a food...</option>' +
            this.currentFoods.map(food => 
                `<option value="${food.id}">${food.food_name} (${food.calories} cal)</option>`
            ).join('');
    }

    async handleAddFavorite() {
        const foodId = document.getElementById('favorite-food-id').value;
        
        const result = await this.client.addFavorite(foodId);
        this.showResponse(result, !result.success);
        
        if (result.success) {
            document.getElementById('favorite-form').reset();
            await this.loadFavorites();
        }
    }

    async removeFavorite(id) {
        if (!confirm('Remove this food from favorites?')) return;
        
        const result = await this.client.removeFavorite(id);
        this.showResponse(result, !result.success);
        
        if (result.success) {
            await this.loadFavorites();
        }
    }

    async loadFavorites() {
        if (!this.client.isAuthenticated()) {
            this.renderFavorites();
            return;
        }

        const result = await this.client.getFavorites();
        if (result.success) {
            this.currentFavorites = result.data;
        } else {
            this.currentFavorites = [];
        }
        this.renderFavorites();
    }

    renderFavorites() {
        const favoritesList = document.getElementById('favorites-list');
        
        if (!this.client.isAuthenticated()) {
            favoritesList.innerHTML = '<p class="info-message">Please login to view favorites.</p>';
            return;
        }

        if (this.currentFavorites.length === 0) {
            favoritesList.innerHTML = '<p class="info-message">No favorites yet. Add some foods to your favorites!</p>';
            return;
        }

        favoritesList.innerHTML = `
            <table class="favorites-table">
                <thead>
                    <tr>
                        <th>Favorite ID</th>
                        <th>Food ID</th>
                        <th>Food Name</th>
                        <th>Calories</th>
                        <th>Last Updated</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    ${this.currentFavorites.map(fav => {
                        return `
                        <tr>
                            <td>${fav.favorite_id}</td>
                            <td>${fav.food_id}</td>
                            <td>${fav.food ? fav.food.food_name : 'N/A'}</td>
                            <td>${fav.food ? fav.food.calories : 'N/A'}</td>
                            <td>${this.formatDate(fav.updated_at)}</td>
                            <td class="actions">
                                <button class="btn-delete" data-favorite-id="${fav.favorite_id}">Remove</button>
                            </td>
                        </tr>
                    `}).join('')}
                </tbody>
            </table>
        `;

        // Attach event listeners to favorite action buttons
        favoritesList.querySelectorAll('.btn-delete').forEach(btn => {
            btn.addEventListener('click', () => {
                this.removeFavorite(parseInt(btn.dataset.favoriteId));
            });
        });
    }
}

// Initialize when DOM is ready
function initAPIClient() {
    const appDiv = document.getElementById('api-client-app');
    if (!appDiv) {
        console.error('api-client-app div not found');
        return;
    }
    
    apiClientUI = new EatoAPIClientUI();
    apiClientUI.init();
}

let apiClientUI;
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initAPIClient);
} else {
    // DOM already loaded, but wait a tick to ensure content is rendered
    setTimeout(initAPIClient, 0);
}
