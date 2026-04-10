/* ================================================================
   Ghana Maternal & Neonatal Health Dashboard — Application
   ================================================================ */

// ── Color palette ──────────────────────────────────────────────
const COLORS = {
    blue: '#4e8cff',
    teal: '#36d6b5',
    coral: '#ff6b6b',
    amber: '#f5a623',
    purple: '#a78bfa',
    pink: '#f472b6',
    green: '#34d399',
    cyan: '#22d3ee',
    indigo: '#818cf8',
    rose: '#fb7185',
    lime: '#a3e635',
    sky: '#38bdf8',
};

const PALETTE = [
    COLORS.blue, COLORS.teal, COLORS.coral, COLORS.amber,
    COLORS.purple, COLORS.pink, COLORS.green, COLORS.cyan,
    COLORS.indigo, COLORS.rose, COLORS.lime, COLORS.sky,
];

const PALETTE_ALPHA = PALETTE.map(c => c + '33');

// Chart.js defaults
Chart.defaults.color = '#9ba3b5';
Chart.defaults.borderColor = 'rgba(255,255,255,0.06)';
Chart.defaults.font.family = "'Inter', sans-serif";
Chart.defaults.font.size = 12;
Chart.defaults.plugins.legend.labels.boxWidth = 12;
Chart.defaults.plugins.legend.labels.padding = 16;
Chart.defaults.plugins.tooltip.backgroundColor = '#1e2440';
Chart.defaults.plugins.tooltip.borderColor = 'rgba(255,255,255,0.1)';
Chart.defaults.plugins.tooltip.borderWidth = 1;
Chart.defaults.plugins.tooltip.cornerRadius = 8;
Chart.defaults.plugins.tooltip.padding = 12;

let DATA = null;
let map = null;
let geoLayer = null;

// ── Ghana GeoJSON (simplified region boundaries) ───────────────
const GHANA_REGIONS = {
    "type": "FeatureCollection",
    "features": [
        {"type":"Feature","properties":{"name":"Western"},"geometry":{"type":"Polygon","coordinates":[[[-3.2,5.0],[-2.0,5.0],[-1.8,5.5],[-1.6,6.3],[-2.0,6.6],[-2.5,6.8],[-3.2,6.3],[-3.3,5.6],[-3.2,5.0]]]}},
        {"type":"Feature","properties":{"name":"Central"},"geometry":{"type":"Polygon","coordinates":[[[-2.0,5.0],[-1.0,5.0],[-0.8,5.4],[-0.9,6.0],[-1.0,6.3],[-1.6,6.3],[-1.8,5.5],[-2.0,5.0]]]}},
        {"type":"Feature","properties":{"name":"Greater Accra"},"geometry":{"type":"Polygon","coordinates":[[[-0.5,5.4],[-0.0,5.5],[0.2,5.7],[0.1,5.9],[-0.2,6.0],[-0.5,5.9],[-0.8,5.6],[-0.5,5.4]]]}},
        {"type":"Feature","properties":{"name":"Volta"},"geometry":{"type":"Polygon","coordinates":[[[0.2,5.7],[0.5,5.8],[1.1,6.1],[1.2,7.0],[0.9,7.5],[0.5,8.0],[0.2,8.3],[0.0,7.5],[-0.1,6.8],[-0.2,6.0],[0.1,5.9],[0.2,5.7]]]}},
        {"type":"Feature","properties":{"name":"Eastern"},"geometry":{"type":"Polygon","coordinates":[[[-0.8,5.6],[-0.5,5.9],[-0.2,6.0],[-0.1,6.8],[0.0,7.5],[-0.3,7.5],[-0.8,7.2],[-1.0,6.8],[-1.0,6.3],[-0.9,6.0],[-0.8,5.6]]]}},
        {"type":"Feature","properties":{"name":"Ashanti"},"geometry":{"type":"Polygon","coordinates":[[[-2.5,6.8],[-2.0,6.6],[-1.6,6.3],[-1.0,6.3],[-1.0,6.8],[-0.8,7.2],[-0.3,7.5],[-0.5,7.8],[-1.0,7.8],[-1.5,7.5],[-2.0,7.5],[-2.5,7.3],[-2.5,6.8]]]}},
        {"type":"Feature","properties":{"name":"Brong Ahafo"},"geometry":{"type":"Polygon","coordinates":[[[-3.2,6.3],[-2.5,6.8],[-2.5,7.3],[-2.0,7.5],[-1.5,7.5],[-1.0,7.8],[-0.5,7.8],[0.0,7.5],[0.2,8.3],[-0.2,8.5],[-0.8,8.5],[-1.5,8.3],[-2.5,8.2],[-3.0,7.8],[-3.2,7.2],[-3.2,6.3]]]}},
        {"type":"Feature","properties":{"name":"Northern"},"geometry":{"type":"Polygon","coordinates":[[[-2.5,8.2],[-1.5,8.3],[-0.8,8.5],[-0.2,8.5],[0.2,8.3],[0.5,8.0],[0.6,9.0],[0.5,9.5],[0.2,10.0],[-0.5,10.2],[-1.0,10.1],[-1.5,10.0],[-2.0,9.8],[-2.5,9.5],[-2.8,9.0],[-2.5,8.2]]]}},
        {"type":"Feature","properties":{"name":"Upper East"},"geometry":{"type":"Polygon","coordinates":[[[-1.5,10.0],[-1.0,10.1],[-0.5,10.2],[0.2,10.0],[0.3,10.5],[0.2,11.0],[-0.2,11.1],[-0.8,11.1],[-1.2,10.8],[-1.5,10.5],[-1.5,10.0]]]}},
        {"type":"Feature","properties":{"name":"Upper West"},"geometry":{"type":"Polygon","coordinates":[[[-2.8,9.8],[-2.5,9.5],[-2.0,9.8],[-1.5,10.0],[-1.5,10.5],[-1.2,10.8],[-1.5,11.0],[-2.0,11.1],[-2.5,11.0],[-2.8,10.5],[-2.8,9.8]]]}}
    ]
};

// ── Data Loading ───────────────────────────────────────────────
async function loadData() {
    const resp = await fetch('data/dashboard_data.json');
    DATA = await resp.json();
    initDashboard();
}

function initDashboard() {
    populateOverview();
    initMap();
    buildCharts();
    buildMortalityFunnel();
    setupScrollSpy();
    animateCounters();
}

// ── Overview / Indicators ──────────────────────────────────────
function populateOverview() {
    const o = DATA.overview;
    document.getElementById('ind-nmr').textContent = o.neonatal_mortality_rate.toFixed(1);
    document.getElementById('ind-imr').textContent = o.infant_mortality_rate.toFixed(1);
    document.getElementById('ind-maternal').textContent = o.maternal_deaths_va.toLocaleString();
    document.getElementById('ind-sbr').textContent = o.stillbirth_rate.toFixed(1);

    // Care stats
    document.getElementById('stat-csection').textContent = DATA.csection.rate + '%';
    document.getElementById('stat-pnc-mother').textContent = DATA.postnatal_care.mother_check_pct + '%';
    document.getElementById('stat-pnc-child').textContent = DATA.postnatal_care.child_check_pct + '%';
    document.getElementById('stat-complications').textContent = DATA.delivery_complications.rate + '%';
    document.getElementById('stat-care-seeking').textContent = DATA.complication_care_seeking.pct_sought + '%';
    document.getElementById('stat-contraceptive').textContent = DATA.contraceptive_use.prevalence_pct + '%';
}

// ── Counter Animation ──────────────────────────────────────────
function animateCounters() {
    const counters = document.querySelectorAll('.hero-stat');
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                const target = parseInt(entry.target.dataset.count);
                const el = entry.target.querySelector('.hero-stat-number');
                animateValue(el, 0, target, 2000);
                observer.unobserve(entry.target);
            }
        });
    }, { threshold: 0.5 });
    counters.forEach(c => observer.observe(c));
}

function animateValue(el, start, end, duration) {
    const startTime = performance.now();
    function update(currentTime) {
        const elapsed = currentTime - startTime;
        const progress = Math.min(elapsed / duration, 1);
        const eased = 1 - Math.pow(1 - progress, 3);
        const current = Math.round(start + (end - start) * eased);
        el.textContent = current.toLocaleString();
        if (progress < 1) requestAnimationFrame(update);
    }
    requestAnimationFrame(update);
}

// ── Map ────────────────────────────────────────────────────────
function initMap() {
    map = L.map('ghana-map', {
        center: [7.95, -1.0],
        zoom: 7,
        zoomControl: true,
        attributionControl: false,
        scrollWheelZoom: true,
    });

    L.tileLayer('https://{s}.basemaps.cartocdn.com/dark_nolabels/{z}/{x}/{y}{r}.png', {
        maxZoom: 19,
    }).addTo(map);

    function getRegionColor(nmr) {
        if (nmr >= 40) return '#ef4444';
        if (nmr >= 35) return '#f97316';
        if (nmr >= 30) return '#f59e0b';
        if (nmr >= 25) return '#eab308';
        if (nmr >= 20) return '#84cc16';
        return '#22c55e';
    }

    geoLayer = L.geoJSON(GHANA_REGIONS, {
        style: function(feature) {
            const name = feature.properties.name;
            const rd = DATA.regional[name];
            const nmr = rd ? rd.neonatal_mortality_rate : 0;
            return {
                fillColor: getRegionColor(nmr),
                weight: 2,
                opacity: 0.8,
                color: 'rgba(255,255,255,0.3)',
                fillOpacity: 0.6,
            };
        },
        onEachFeature: function(feature, layer) {
            const name = feature.properties.name;
            const rd = DATA.regional[name];
            if (!rd) return;

            layer.bindPopup(`
                <div class="region-popup">
                    <h4>${name} Region</h4>
                    <div class="popup-stat"><span>Pregnancies</span><span>${rd.total_pregnancies.toLocaleString()}</span></div>
                    <div class="popup-stat"><span>Live Births</span><span>${rd.live_births.toLocaleString()}</span></div>
                    <div class="popup-stat"><span>NMR (per 1,000)</span><span>${rd.neonatal_mortality_rate}</span></div>
                    <div class="popup-stat"><span>ANC Coverage</span><span>${rd.anc_coverage}%</span></div>
                </div>
            `);

            layer.on({
                mouseover: function(e) {
                    e.target.setStyle({ weight: 3, fillOpacity: 0.8, color: '#fff' });
                    e.target.bringToFront();
                },
                mouseout: function(e) {
                    geoLayer.resetStyle(e.target);
                },
                click: function(e) {
                    showRegionSidebar(name);
                }
            });
        }
    }).addTo(map);

    // Legend
    const legendEl = document.getElementById('map-legend');
    const ranges = [
        { color: '#22c55e', label: '< 20' },
        { color: '#84cc16', label: '20-25' },
        { color: '#eab308', label: '25-30' },
        { color: '#f59e0b', label: '30-35' },
        { color: '#f97316', label: '35-40' },
        { color: '#ef4444', label: '40+' },
    ];
    legendEl.innerHTML = '<span style="font-size:12px;color:#9ba3b5;margin-right:8px;">Neonatal Mortality Rate (per 1,000):</span>' +
        ranges.map(r => `<div class="legend-item"><div class="legend-color" style="background:${r.color}"></div>${r.label}</div>`).join('');
}

function showRegionSidebar(name) {
    const rd = DATA.regional[name];
    if (!rd) return;

    document.querySelector('.sidebar-placeholder').style.display = 'none';
    const content = document.getElementById('sidebar-content');
    content.style.display = 'block';
    document.getElementById('sidebar-region-name').textContent = name + ' Region';

    const grid = document.getElementById('sidebar-grid');
    grid.innerHTML = '';

    const stats = [
        { label: 'Total Pregnancies', value: rd.total_pregnancies.toLocaleString(), color: COLORS.blue },
        { label: 'Live Births', value: rd.live_births.toLocaleString(), color: COLORS.green },
        { label: 'Stillbirths', value: rd.stillbirths.toLocaleString(), color: COLORS.coral },
        { label: 'Neonatal Deaths', value: rd.neonatal_deaths.toLocaleString(), color: COLORS.amber },
        { label: 'NMR (per 1,000)', value: rd.neonatal_mortality_rate, color: COLORS.coral, full: true },
        { label: 'ANC Coverage', value: rd.anc_coverage + '%', color: COLORS.teal },
        { label: 'Facility Delivery', value: rd.facility_delivery_pct + '%', color: COLORS.blue },
        { label: 'Home Delivery', value: rd.home_delivery_pct + '%', color: COLORS.amber },
        { label: 'C-Section Rate', value: rd.csection_rate + '%', color: COLORS.purple },
        { label: 'Skilled Attendance', value: rd.skilled_birth_pct + '%', color: COLORS.teal },
        { label: 'Maternal Deaths', value: rd.maternal_deaths, color: COLORS.coral },
        { label: 'Total VA Deaths', value: rd.total_va_deaths, color: COLORS.pink },
    ];

    stats.forEach(s => {
        const div = document.createElement('div');
        div.className = 'sidebar-stat' + (s.full ? ' full-width' : '');
        div.innerHTML = `<div class="sidebar-stat-value" style="color:${s.color}">${s.value}</div>
                         <div class="sidebar-stat-label">${s.label}</div>`;
        grid.appendChild(div);
    });
}

// ── Charts ─────────────────────────────────────────────────────
function buildCharts() {
    // Pregnancy outcomes (doughnut)
    createDoughnut('chart-pregout', DATA.pregnancy_outcomes, [COLORS.green, COLORS.coral, COLORS.amber, COLORS.purple]);

    // Pregnancy outcomes by region (stacked bar)
    createStackedBar('chart-pregout-region', DATA.pregnancy_outcomes_by_region);

    // Urban vs Rural outcomes
    createGroupedBar('chart-pregout-residence', DATA.pregnancy_outcomes_by_residence);

    // Child size at birth
    createHorizontalBar('chart-birthsize', DATA.child_size_at_birth, [COLORS.blue, COLORS.teal, COLORS.green, COLORS.amber, COLORS.coral]);

    // Maternal death timing (doughnut)
    createDoughnut('chart-maternal-timing', DATA.maternal_death_timing,
        [COLORS.green, COLORS.coral, COLORS.amber, COLORS.purple, COLORS.pink]);

    // ICD-10 causes (horizontal bar)
    createHorizontalBar('chart-icd10', DATA.icd10_causes, PALETTE);

    // Maternal complications
    createHorizontalBar('chart-maternal-comp', DATA.maternal_complications, PALETTE);

    // Place of death
    createDoughnut('chart-death-place', DATA.place_of_death,
        [COLORS.blue, COLORS.teal, COLORS.coral, COLORS.amber, COLORS.purple, COLORS.pink]);

    // Deaths by year (line)
    createLineChart('chart-deaths-year', DATA.deaths_by_year, COLORS.coral);

    // Age at death
    createBarChart('chart-age-death', DATA.va_age_at_death, COLORS.purple);

    // VA deaths by region
    createBarChart('chart-va-region', DATA.va_deaths_by_region, COLORS.blue);

    // Neonatal by sex
    createNeoComparison('chart-neo-sex', DATA.neonatal_by_sex);

    // Neonatal by residence
    createNeoComparison('chart-neo-residence', DATA.neonatal_by_residence);

    // Neonatal by birth type
    createNeoComparison('chart-neo-birthtype', DATA.neonatal_by_birth_type);

    // Neonatal timing
    createDoughnut('chart-neo-timing', DATA.neonatal_timing, [COLORS.coral, COLORS.amber]);

    // NMR by region
    const nmrByRegion = {};
    for (const [name, rd] of Object.entries(DATA.regional)) {
        nmrByRegion[name] = rd.neonatal_mortality_rate;
    }
    createBarChart('chart-neo-region', nmrByRegion, COLORS.coral);

    // Birth weight
    createDoughnut('chart-birthweight', DATA.birth_weight,
        [COLORS.coral, COLORS.amber, COLORS.green, COLORS.blue]);

    // ANC gauge
    drawGauge('gauge-anc', DATA.anc.coverage_pct);

    // ANC visits
    createBarChart('chart-anc-visits', DATA.anc_visits, COLORS.teal);

    // ANC services (radar)
    createRadarChart('chart-anc-services', DATA.anc_services, COLORS.blue);

    // Preventive care (horizontal bar)
    createHorizontalBar('chart-preventive', DATA.preventive_care, [COLORS.teal, COLORS.green, COLORS.blue]);

    // Delivery place (pie)
    createDoughnut('chart-delivery-place', DATA.delivery_place_grouped,
        [COLORS.blue, COLORS.amber, COLORS.purple]);

    // Delivery assistance
    createHorizontalBar('chart-delivery-assist', DATA.delivery_assistance, PALETTE);

    // Facility delivery by region
    createBarChart('chart-facility-region', DATA.facility_delivery_by_region, COLORS.blue);

    // Skilled birth attendance by region
    createBarChart('chart-sba-region', DATA.skilled_attendance_by_region, COLORS.teal);

    // Demographics
    createBarChart('chart-age-dist', DATA.women_age_distribution, COLORS.purple);
    createDoughnut('chart-education', DATA.education, PALETTE);
    createDoughnut('chart-wealth', DATA.wealth_index,
        [COLORS.coral, COLORS.amber, COLORS.blue, COLORS.teal, COLORS.green]);
    createDoughnut('chart-religion', DATA.religion, PALETTE);
    createDoughnut('chart-ethnicity', DATA.ethnicity, PALETTE);
    createDoughnut('chart-residence', DATA.residence_type, [COLORS.blue, COLORS.green]);
}

// ── Chart Factory Functions ────────────────────────────────────

function createDoughnut(canvasId, data, colors) {
    const labels = Object.keys(data);
    const values = Object.values(data);
    const total = values.reduce((a, b) => a + b, 0);

    new Chart(document.getElementById(canvasId), {
        type: 'doughnut',
        data: {
            labels,
            datasets: [{
                data: values,
                backgroundColor: colors,
                borderColor: 'rgba(0,0,0,0.3)',
                borderWidth: 2,
                hoverOffset: 6,
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            cutout: '60%',
            plugins: {
                legend: { position: 'bottom', labels: { padding: 12, font: { size: 11 } } },
                tooltip: {
                    callbacks: {
                        label: ctx => {
                            const pct = ((ctx.raw / total) * 100).toFixed(1);
                            return `${ctx.label}: ${ctx.raw.toLocaleString()} (${pct}%)`;
                        }
                    }
                }
            }
        }
    });
}

function createBarChart(canvasId, data, color) {
    const labels = Object.keys(data);
    const values = Object.values(data);

    new Chart(document.getElementById(canvasId), {
        type: 'bar',
        data: {
            labels,
            datasets: [{
                data: values,
                backgroundColor: color + '88',
                borderColor: color,
                borderWidth: 1,
                borderRadius: 4,
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: { legend: { display: false } },
            scales: {
                x: { grid: { display: false }, ticks: { maxRotation: 45, font: { size: 10 } } },
                y: { beginAtZero: true, grid: { color: 'rgba(255,255,255,0.04)' } }
            }
        }
    });
}

function createHorizontalBar(canvasId, data, colors) {
    const labels = Object.keys(data);
    const values = Object.values(data);

    new Chart(document.getElementById(canvasId), {
        type: 'bar',
        data: {
            labels,
            datasets: [{
                data: values,
                backgroundColor: labels.map((_, i) => (colors[i % colors.length]) + '88'),
                borderColor: labels.map((_, i) => colors[i % colors.length]),
                borderWidth: 1,
                borderRadius: 4,
            }]
        },
        options: {
            indexAxis: 'y',
            responsive: true,
            maintainAspectRatio: false,
            plugins: { legend: { display: false } },
            scales: {
                x: { beginAtZero: true, grid: { color: 'rgba(255,255,255,0.04)' } },
                y: { grid: { display: false }, ticks: { font: { size: 10 } } }
            }
        }
    });
}

function createLineChart(canvasId, data, color) {
    const labels = Object.keys(data);
    const values = Object.values(data);

    new Chart(document.getElementById(canvasId), {
        type: 'line',
        data: {
            labels,
            datasets: [{
                data: values,
                borderColor: color,
                backgroundColor: color + '22',
                fill: true,
                tension: 0.4,
                pointRadius: 4,
                pointHoverRadius: 6,
                pointBackgroundColor: color,
                pointBorderColor: '#151a2e',
                pointBorderWidth: 2,
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: { legend: { display: false } },
            scales: {
                x: { grid: { display: false }, ticks: { font: { size: 10 } } },
                y: { beginAtZero: true, grid: { color: 'rgba(255,255,255,0.04)' } }
            }
        }
    });
}

function createStackedBar(canvasId, data) {
    const regions = Object.keys(data);
    const outcomes = Object.keys(data[regions[0]]);
    const outcomeColors = [COLORS.green, COLORS.coral, COLORS.amber, COLORS.purple];

    const datasets = outcomes.map((outcome, i) => ({
        label: outcome,
        data: regions.map(r => data[r][outcome]),
        backgroundColor: outcomeColors[i] + '88',
        borderColor: outcomeColors[i],
        borderWidth: 1,
    }));

    new Chart(document.getElementById(canvasId), {
        type: 'bar',
        data: { labels: regions, datasets },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { position: 'bottom', labels: { font: { size: 10 } } }
            },
            scales: {
                x: { stacked: true, grid: { display: false }, ticks: { maxRotation: 45, font: { size: 9 } } },
                y: { stacked: true, grid: { color: 'rgba(255,255,255,0.04)' } }
            }
        }
    });
}

function createGroupedBar(canvasId, data) {
    const groups = Object.keys(data);
    const categories = Object.keys(data[groups[0]]);
    const catColors = [COLORS.green, COLORS.coral, COLORS.amber, COLORS.purple];

    const datasets = categories.map((cat, i) => ({
        label: cat,
        data: groups.map(g => data[g][cat]),
        backgroundColor: catColors[i] + '88',
        borderColor: catColors[i],
        borderWidth: 1,
        borderRadius: 4,
    }));

    new Chart(document.getElementById(canvasId), {
        type: 'bar',
        data: { labels: groups, datasets },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: { legend: { position: 'bottom', labels: { font: { size: 11 } } } },
            scales: {
                x: { grid: { display: false } },
                y: { beginAtZero: true, grid: { color: 'rgba(255,255,255,0.04)' } }
            }
        }
    });
}

function createNeoComparison(canvasId, data) {
    const labels = Object.keys(data);
    const deaths = labels.map(k => data[k].deaths);
    const rates = labels.map(k => data[k].rate);

    new Chart(document.getElementById(canvasId), {
        type: 'bar',
        data: {
            labels,
            datasets: [
                {
                    label: 'Deaths',
                    data: deaths,
                    backgroundColor: COLORS.coral + '88',
                    borderColor: COLORS.coral,
                    borderWidth: 1,
                    borderRadius: 4,
                    yAxisID: 'y',
                },
                {
                    label: 'Rate (per 1,000)',
                    data: rates,
                    type: 'line',
                    borderColor: COLORS.amber,
                    backgroundColor: COLORS.amber + '22',
                    pointBackgroundColor: COLORS.amber,
                    pointRadius: 6,
                    pointHoverRadius: 8,
                    yAxisID: 'y1',
                    tension: 0.4,
                }
            ]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: { legend: { position: 'bottom', labels: { font: { size: 11 } } } },
            scales: {
                x: { grid: { display: false } },
                y: { beginAtZero: true, position: 'left', title: { display: true, text: 'Deaths', font: { size: 10 } }, grid: { color: 'rgba(255,255,255,0.04)' } },
                y1: { beginAtZero: true, position: 'right', title: { display: true, text: 'Rate per 1,000', font: { size: 10 } }, grid: { display: false } }
            }
        }
    });
}

function createRadarChart(canvasId, data, color) {
    const labels = Object.keys(data);
    const values = Object.values(data);

    new Chart(document.getElementById(canvasId), {
        type: 'radar',
        data: {
            labels,
            datasets: [{
                data: values,
                backgroundColor: color + '33',
                borderColor: color,
                borderWidth: 2,
                pointBackgroundColor: color,
                pointRadius: 4,
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: { legend: { display: false } },
            scales: {
                r: {
                    beginAtZero: true,
                    max: 100,
                    ticks: { stepSize: 25, font: { size: 9 }, backdropColor: 'transparent' },
                    grid: { color: 'rgba(255,255,255,0.06)' },
                    pointLabels: { font: { size: 10 }, color: '#9ba3b5' },
                    angleLines: { color: 'rgba(255,255,255,0.06)' },
                }
            }
        }
    });
}

// ── Gauge Drawing ──────────────────────────────────────────────
function drawGauge(canvasId, value) {
    const canvas = document.getElementById(canvasId);
    const ctx = canvas.getContext('2d');
    const dpr = window.devicePixelRatio || 1;
    canvas.width = 300 * dpr;
    canvas.height = 200 * dpr;
    ctx.scale(dpr, dpr);

    const cx = 150, cy = 150, r = 100;
    const startAngle = Math.PI;
    const endAngle = 2 * Math.PI;
    const valueAngle = startAngle + (value / 100) * Math.PI;

    // Background arc
    ctx.beginPath();
    ctx.arc(cx, cy, r, startAngle, endAngle);
    ctx.lineWidth = 20;
    ctx.strokeStyle = '#1e2440';
    ctx.lineCap = 'round';
    ctx.stroke();

    // Value arc with gradient
    const grad = ctx.createLinearGradient(50, cy, 250, cy);
    grad.addColorStop(0, COLORS.coral);
    grad.addColorStop(0.5, COLORS.amber);
    grad.addColorStop(1, COLORS.green);

    ctx.beginPath();
    ctx.arc(cx, cy, r, startAngle, valueAngle);
    ctx.lineWidth = 20;
    ctx.strokeStyle = grad;
    ctx.lineCap = 'round';
    ctx.stroke();

    // Value text
    ctx.fillStyle = '#f0f2f5';
    ctx.font = 'bold 42px Inter';
    ctx.textAlign = 'center';
    ctx.fillText(value + '%', cx, cy - 10);

    // Sub text
    ctx.fillStyle = '#9ba3b5';
    ctx.font = '13px Inter';
    ctx.fillText('of women received ANC', cx, cy + 15);
}

// ── Mortality Funnel ───────────────────────────────────────────
function buildMortalityFunnel() {
    const o = DATA.overview;
    const items = [
        { label: 'Live Births', value: o.live_births, color: COLORS.green },
        { label: 'Under-5 Deaths', value: o.under5_deaths, color: COLORS.amber },
        { label: 'Infant Deaths', value: o.infant_deaths, color: COLORS.coral },
        { label: 'Neonatal Deaths', value: o.neonatal_deaths, color: COLORS.pink },
    ];

    const maxVal = items[0].value;
    const container = document.getElementById('mortality-funnel');
    container.innerHTML = '';

    items.forEach(item => {
        const pct = (item.value / maxVal) * 100;
        const div = document.createElement('div');
        div.className = 'funnel-item';
        div.innerHTML = `
            <div class="funnel-label">${item.label}</div>
            <div class="funnel-bar-bg">
                <div class="funnel-bar" style="width:${pct}%;background:${item.color}">${item.value.toLocaleString()}</div>
            </div>
        `;
        container.appendChild(div);
    });
}

// ── Scroll Spy / Nav ───────────────────────────────────────────
function setupScrollSpy() {
    const navbar = document.getElementById('navbar');
    const sections = document.querySelectorAll('.section, .hero');
    const navLinks = document.querySelectorAll('.nav-link');

    window.addEventListener('scroll', () => {
        // Navbar background
        if (window.scrollY > 50) {
            navbar.classList.add('scrolled');
        } else {
            navbar.classList.remove('scrolled');
        }

        // Active section
        let current = '';
        sections.forEach(section => {
            const top = section.offsetTop - 100;
            if (window.scrollY >= top) {
                current = section.id || '';
            }
        });

        navLinks.forEach(link => {
            link.classList.remove('active');
            if (link.dataset.section === current || (current === '' && link.dataset.section === 'overview')) {
                link.classList.add('active');
            }
        });
    });
}

// ── Share Modal ────────────────────────────────────────────────
function openShareModal() {
    document.getElementById('share-modal').classList.add('open');
}

function closeShareModal(e) {
    if (e.target === document.getElementById('share-modal') || e.target.classList.contains('modal-close')) {
        document.getElementById('share-modal').classList.remove('open');
    }
}

function shareVia(platform) {
    const url = window.location.href;
    const text = 'Ghana Maternal & Neonatal Health Dashboard - Comprehensive data visualizations from Ghana DHS';

    switch (platform) {
        case 'twitter':
            window.open(`https://twitter.com/intent/tweet?text=${encodeURIComponent(text)}&url=${encodeURIComponent(url)}`, '_blank');
            break;
        case 'linkedin':
            window.open(`https://www.linkedin.com/sharing/share-offsite/?url=${encodeURIComponent(url)}`, '_blank');
            break;
        case 'copy':
            navigator.clipboard.writeText(url).then(() => {
                const btn = document.querySelector('.share-option:last-of-type');
                btn.innerHTML = '<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="20 6 9 17 4 12"/></svg> Copied!';
                setTimeout(() => {
                    btn.innerHTML = '<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="9" y="9" width="13" height="13" rx="2" ry="2"/><path d="M5 15H4a2 2 0 01-2-2V4a2 2 0 012-2h9a2 2 0 012 2v1"/></svg> Copy Link';
                }, 2000);
            });
            break;
    }
}

// ── Initialize ─────────────────────────────────────────────────
document.addEventListener('DOMContentLoaded', loadData);
