"""
Extract and aggregate data from Ghana DHS SPSS datasets for the web dashboard.
Produces a single JSON file with all visualization data.
"""
import pyreadstat
import pandas as pd
import numpy as np
import json

BASE = "OneDrive - University of Idaho/Documents/Ghana Maternal Neonatal Data/Data"

REGION_LABELS = {
    1.0: 'Western', 2.0: 'Central', 3.0: 'Greater Accra', 4.0: 'Volta',
    5.0: 'Eastern', 6.0: 'Ashanti', 7.0: 'Brong Ahafo', 8.0: 'Northern',
    9.0: 'Upper East', 10.0: 'Upper West'
}

TYPE_LABELS = {1.0: 'Urban', 2.0: 'Rural'}
WEALTH_LABELS = {1.0: 'Lowest', 2.0: 'Second', 3.0: 'Middle', 4.0: 'Fourth', 5.0: 'Highest'}
EDUCATION_LABELS = {0.0: 'No education', 1.0: 'Primary incomplete', 2.0: 'Primary complete',
                    3.0: 'Secondary incomplete', 4.0: 'Secondary complete', 5.0: 'Higher'}
PREGOUT_LABELS = {1.0: 'Live birth', 2.0: 'Stillbirth', 3.0: 'Miscarriage', 4.0: 'Abortion'}
RELIGION_LABELS = {1.0: 'Catholic', 2.0: 'Anglican', 3.0: 'Methodist', 4.0: 'Presbyterian',
                   5.0: 'Pentecostal/Charismatic', 6.0: 'Other Christian', 7.0: 'Islam',
                   8.0: 'Traditional/Spiritualist', 9.0: 'No religion', 96.0: 'Other'}
ETHNICITY_LABELS = {1.0: 'Akan', 2.0: 'Ga/Dangme', 3.0: 'Ewe', 4.0: 'Guan',
                    5.0: 'Mole-Dagbani', 6.0: 'Grusi', 7.0: 'Gurma', 8.0: 'Mande', 96.0: 'Other'}
DELIVERY_PLACE_LABELS = {
    11.0: 'Home', 12.0: 'Other home', 21.0: 'Govt Hospital',
    22.0: 'Govt Health Center', 23.0: 'Govt Health Post/CHPS',
    24.0: 'Mobile Clinic', 26.0: 'Other Public', 31.0: 'Private Hospital',
    32.0: 'FP/PPAG Clinic', 33.0: 'Private Mobile', 34.0: 'Maternity Home',
    36.0: 'Other Private', 96.0: 'Other'
}
DELIVERY_ASSIST_LABELS = {
    'A': 'Doctor', 'B': 'Nurse/Midwife', 'C': 'Community Health Officer',
    'D': 'Traditional Birth Attendant', 'E': 'Village Health Volunteer',
    'F': 'Traditional Practitioner', 'G': 'Relative/Friend',
    'X': 'Other', 'Y': 'No one assisted'
}
DEATH_PREGNANCY_LABELS = {
    1.0: 'Not pregnancy-related',
    2.0: 'During pregnancy',
    3.0: 'During childbirth',
    4.0: 'Within 42 days postpartum',
    5.0: '43 days to 1 year postpartum'
}

def safe_count(series, value):
    return int((series == value).sum())

def safe_pct(num, denom):
    return round(num / denom * 100, 1) if denom > 0 else 0

def label_counts(series, labels, weight=None):
    """Get labeled counts from a series using provided label mapping."""
    result = {}
    for val, label in labels.items():
        if weight is not None:
            mask = series == val
            result[label] = round(float(weight[mask].sum()), 1)
        else:
            result[label] = int((series == val).sum())
    return result

def extract_all():
    print("Loading datasets...")
    bq, bq_meta = pyreadstat.read_sav(f"{BASE}/GHBQ7ISV/GHBQ7IFL.SAV")
    iq, iq_meta = pyreadstat.read_sav(f"{BASE}/GHIQ7ISV/GHIQ7IFL.SAV")
    hh, hh_meta = pyreadstat.read_sav(f"{BASE}/GHHH7ISV/GHHH7IFL.SAV")
    va, va_meta = pyreadstat.read_sav(f"{BASE}/GHVA7ISV-1/GHVA7IFL_ALLYEARS.SAV")
    ch, ch_meta = pyreadstat.read_sav(f"{BASE}/GHCH7ISV/GHCH7IFL.SAV")

    dashboard = {}

    # ── 1. Overview statistics ──────────────────────────────────
    print("Computing overview stats...")
    total_births = len(bq)
    live_births = safe_count(bq['PREGOUT'], 1.0)
    stillbirths = safe_count(bq['PREGOUT'], 2.0)
    miscarriages = safe_count(bq['PREGOUT'], 3.0)
    abortions = safe_count(bq['PREGOUT'], 4.0)

    # Children who died (from birth questionnaire, Q216=2 means not alive)
    children_died = safe_count(bq['Q216'], 2.0)

    # Neonatal deaths (died within 28 days): Q220U=1 (days) and Q220N<=28
    neonatal_mask = (bq['Q220U'] == 1) & (bq['Q220N'] <= 28)
    neonatal_deaths = int(neonatal_mask.sum())

    # Infant deaths (died within 1 year): days<=365 or months<=11
    infant_days = (bq['Q220U'] == 1) & (bq['Q220N'] <= 365)
    infant_months = (bq['Q220U'] == 2) & (bq['Q220N'] <= 11)
    infant_deaths = int((infant_days | infant_months).sum())

    # Under-5 deaths
    under5_years = (bq['Q220U'] == 3) & (bq['Q220N'] <= 4)
    under5_deaths = int((infant_days | infant_months | under5_years).sum())

    total_women = len(iq)
    total_households = len(hh)
    total_va_deaths = len(va)

    # Maternal deaths from VA
    maternal_deaths_va = int(va['CDDEATHP'].isin([2.0, 3.0, 4.0]).sum())

    dashboard['overview'] = {
        'total_pregnancies': total_births,
        'live_births': live_births,
        'stillbirths': stillbirths,
        'miscarriages': miscarriages,
        'abortions': abortions,
        'neonatal_deaths': neonatal_deaths,
        'infant_deaths': infant_deaths,
        'under5_deaths': under5_deaths,
        'children_died': children_died,
        'total_women_surveyed': total_women,
        'total_households': total_households,
        'total_verbal_autopsies': total_va_deaths,
        'maternal_deaths_va': maternal_deaths_va,
        'neonatal_mortality_rate': safe_pct(neonatal_deaths, live_births) * 10,  # per 1000
        'infant_mortality_rate': safe_pct(infant_deaths, live_births) * 10,
        'stillbirth_rate': safe_pct(stillbirths, total_births) * 10,
    }

    # ── 2. Pregnancy outcomes ───────────────────────────────────
    print("Computing pregnancy outcomes...")
    dashboard['pregnancy_outcomes'] = label_counts(bq['PREGOUT'], PREGOUT_LABELS)

    # ── 3. Regional data ────────────────────────────────────────
    print("Computing regional data...")
    regional_data = {}
    for reg_val, reg_name in REGION_LABELS.items():
        reg_bq = bq[bq['QREGION'] == reg_val]
        reg_va = va[va['QREGION'] == reg_val]

        reg_live = safe_count(reg_bq['PREGOUT'], 1.0)
        reg_still = safe_count(reg_bq['PREGOUT'], 2.0)
        reg_neo = int(((reg_bq['Q220U'] == 1) & (reg_bq['Q220N'] <= 28)).sum())
        reg_infant_d = (reg_bq['Q220U'] == 1) & (reg_bq['Q220N'] <= 365)
        reg_infant_m = (reg_bq['Q220U'] == 2) & (reg_bq['Q220N'] <= 11)
        reg_infant = int((reg_infant_d | reg_infant_m).sum())

        # ANC coverage
        reg_anc = safe_count(reg_bq['Q405'], 1.0)
        reg_anc_total = int(reg_bq['Q405'].isin([1.0, 2.0]).sum())

        # Facility delivery
        reg_facility = int(reg_bq['Q430'].isin([21.0, 22.0, 23.0, 24.0, 26.0, 31.0, 32.0, 33.0, 34.0, 36.0]).sum())
        reg_home = int(reg_bq['Q430'].isin([11.0, 12.0]).sum())
        reg_del_total = reg_facility + reg_home

        # C-section
        reg_csection = safe_count(reg_bq['Q433A'], 1.0)
        reg_csection_total = int(reg_bq['Q433A'].isin([1.0, 2.0]).sum())

        # Skilled birth attendance
        reg_skilled = int(reg_bq['Q429'].isin(['A', 'B', 'C']).sum())
        reg_assist_total = int(reg_bq['Q429'].notna().sum())

        # Maternal deaths from VA
        reg_maternal = int(reg_va['CDDEATHP'].isin([2.0, 3.0, 4.0]).sum())

        regional_data[reg_name] = {
            'total_pregnancies': len(reg_bq),
            'live_births': reg_live,
            'stillbirths': reg_still,
            'neonatal_deaths': reg_neo,
            'infant_deaths': reg_infant,
            'anc_coverage': safe_pct(reg_anc, reg_anc_total),
            'facility_delivery_pct': safe_pct(reg_facility, reg_del_total),
            'home_delivery_pct': safe_pct(reg_home, reg_del_total),
            'csection_rate': safe_pct(reg_csection, reg_csection_total),
            'skilled_birth_pct': safe_pct(reg_skilled, reg_assist_total),
            'neonatal_mortality_rate': round(reg_neo / reg_live * 1000, 1) if reg_live > 0 else 0,
            'stillbirth_rate': round(reg_still / len(reg_bq) * 1000, 1) if len(reg_bq) > 0 else 0,
            'maternal_deaths': reg_maternal,
            'total_va_deaths': len(reg_va),
        }
    dashboard['regional'] = regional_data

    # ── 4. Delivery care ────────────────────────────────────────
    print("Computing delivery care...")
    dashboard['delivery_place'] = label_counts(bq['Q430'], DELIVERY_PLACE_LABELS)
    dashboard['delivery_assistance'] = label_counts(bq['Q429'], DELIVERY_ASSIST_LABELS)

    # Grouped delivery place
    facility_codes = [21.0, 22.0, 23.0, 24.0, 26.0, 31.0, 32.0, 33.0, 34.0, 36.0]
    home_codes = [11.0, 12.0]
    dashboard['delivery_place_grouped'] = {
        'Health Facility': int(bq['Q430'].isin(facility_codes).sum()),
        'Home': int(bq['Q430'].isin(home_codes).sum()),
        'Other': int(bq['Q430'].isin([96.0]).sum()),
    }

    # C-section rate
    csection_yes = safe_count(bq['Q433A'], 1.0)
    csection_no = safe_count(bq['Q433A'], 2.0)
    dashboard['csection'] = {
        'yes': csection_yes,
        'no': csection_no,
        'rate': safe_pct(csection_yes, csection_yes + csection_no)
    }

    # ── 5. Antenatal care ───────────────────────────────────────
    print("Computing antenatal care...")
    anc_received = safe_count(bq['Q405'], 1.0)
    anc_not = safe_count(bq['Q405'], 2.0)
    dashboard['anc'] = {
        'received': anc_received,
        'not_received': anc_not,
        'coverage_pct': safe_pct(anc_received, anc_received + anc_not),
    }

    # ANC visits distribution
    anc_visits = bq['Q412'].dropna()
    anc_visits = anc_visits[anc_visits < 90]  # exclude DK/special
    visit_bins = {'0': 0, '1-3': 0, '4-7': 0, '8+': 0}
    for v in anc_visits:
        if v == 0: visit_bins['0'] += 1
        elif v <= 3: visit_bins['1-3'] += 1
        elif v <= 7: visit_bins['4-7'] += 1
        else: visit_bins['8+'] += 1
    dashboard['anc_visits'] = visit_bins

    # ANC services
    anc_services = {}
    for var, label in [('Q413A', 'Blood Pressure'), ('Q413B', 'Urine Sample'),
                       ('Q413C', 'Blood Sample'), ('Q413D', 'Weight'),
                       ('Q413E', 'Told about Complications'), ('Q413F', 'Told where to go')]:
        yes = safe_count(bq[var], 1.0)
        total = int(bq[var].isin([1.0, 2.0]).sum())
        anc_services[label] = safe_pct(yes, total)
    dashboard['anc_services'] = anc_services

    # ── 6. Neonatal mortality by factors ────────────────────────
    print("Computing neonatal mortality by factors...")

    # By sex
    neo_by_sex = {}
    for sex_val, sex_name in {1.0: 'Male', 2.0: 'Female'}.items():
        mask = bq['Q213'] == sex_val
        neo_deaths = int(((bq.loc[mask, 'Q220U'] == 1) & (bq.loc[mask, 'Q220N'] <= 28)).sum())
        neo_live = safe_count(bq.loc[mask, 'PREGOUT'], 1.0)
        neo_by_sex[sex_name] = {
            'deaths': neo_deaths,
            'live_births': neo_live,
            'rate': round(neo_deaths / neo_live * 1000, 1) if neo_live > 0 else 0
        }
    dashboard['neonatal_by_sex'] = neo_by_sex

    # By urban/rural
    neo_by_type = {}
    for type_val, type_name in TYPE_LABELS.items():
        mask = bq['QTYPE'] == type_val
        neo_deaths = int(((bq.loc[mask, 'Q220U'] == 1) & (bq.loc[mask, 'Q220N'] <= 28)).sum())
        neo_live = safe_count(bq.loc[mask, 'PREGOUT'], 1.0)
        neo_by_type[type_name] = {
            'deaths': neo_deaths,
            'live_births': neo_live,
            'rate': round(neo_deaths / neo_live * 1000, 1) if neo_live > 0 else 0
        }
    dashboard['neonatal_by_residence'] = neo_by_type

    # By birth type (single/multiple)
    neo_by_birth_type = {}
    for btype_val, btype_name in {1.0: 'Single', 2.0: 'Multiple'}.items():
        mask = bq['Q212B'] == btype_val
        neo_deaths = int(((bq.loc[mask, 'Q220U'] == 1) & (bq.loc[mask, 'Q220N'] <= 28)).sum())
        neo_live = safe_count(bq.loc[mask, 'PREGOUT'], 1.0)
        neo_by_birth_type[btype_name] = {
            'deaths': neo_deaths,
            'live_births': neo_live,
            'rate': round(neo_deaths / neo_live * 1000, 1) if neo_live > 0 else 0
        }
    dashboard['neonatal_by_birth_type'] = neo_by_birth_type

    # Neonatal death timing (early: 0-6 days, late: 7-27 days)
    neo_early = int(((bq['Q220U'] == 1) & (bq['Q220N'] <= 6)).sum())
    neo_late = int(((bq['Q220U'] == 1) & (bq['Q220N'] >= 7) & (bq['Q220N'] <= 27)).sum())
    dashboard['neonatal_timing'] = {
        'Early neonatal (0-6 days)': neo_early,
        'Late neonatal (7-27 days)': neo_late,
    }

    # ── 7. Verbal autopsy: Maternal mortality ───────────────────
    print("Computing maternal mortality from verbal autopsies...")
    dashboard['maternal_death_timing'] = label_counts(va['CDDEATHP'], DEATH_PREGNANCY_LABELS)

    # Place of death
    dashboard['place_of_death'] = label_counts(va['Q115'], {
        1.0: 'Home', 2.0: 'Other home', 3.0: 'Health facility',
        4.0: 'En route to facility', 5.0: 'Shrine/Prayer camp', 6.0: 'Other'
    })

    # VA deaths by region
    va_by_region = {}
    for reg_val, reg_name in REGION_LABELS.items():
        va_by_region[reg_name] = int((va['QREGION'] == reg_val).sum())
    dashboard['va_deaths_by_region'] = va_by_region

    # Age at death distribution (VA)
    age_at_death = va['Q104'].dropna()
    age_at_death = age_at_death[age_at_death < 96]
    age_bins = {'0-4': 0, '5-14': 0, '15-24': 0, '25-34': 0, '35-44': 0,
                '45-54': 0, '55-64': 0, '65-74': 0, '75+': 0}
    for age in age_at_death:
        if age < 5: age_bins['0-4'] += 1
        elif age < 15: age_bins['5-14'] += 1
        elif age < 25: age_bins['15-24'] += 1
        elif age < 35: age_bins['25-34'] += 1
        elif age < 45: age_bins['35-44'] += 1
        elif age < 55: age_bins['45-54'] += 1
        elif age < 65: age_bins['55-64'] += 1
        elif age < 75: age_bins['65-74'] += 1
        else: age_bins['75+'] += 1
    dashboard['va_age_at_death'] = age_bins

    # VA by urban/rural
    dashboard['va_by_residence'] = label_counts(va['QTYPE'], TYPE_LABELS)

    # Maternal complications in VA
    maternal_va = va[va['CDDEATHP'].isin([2.0, 3.0, 4.0])]
    complications = {}
    for var, label in [('Q618', 'High blood pressure'), ('Q619', 'Foul discharge'),
                       ('Q620', 'Bleeding while pregnant'), ('Q623A', 'Excessive bleeding during delivery'),
                       ('Q624', 'Excessive bleeding after delivery'),
                       ('Q622B', 'Convulsions (last 3 months)'), ('Q622C', 'Blurred vision'),
                       ('Q633', 'Hysterectomy'), ('Q639', 'Abnormal position baby')]:
        if var in maternal_va.columns:
            complications[label] = safe_count(maternal_va[var], 1.0)
    dashboard['maternal_complications'] = complications

    # ICD-10 cause of death (top causes)
    if 'CDICD10I' in va.columns:
        icd_codes = va['CDICD10I'].dropna()
        icd_codes = icd_codes[icd_codes != '']
        # Get chapter/category from first letter
        icd_chapter_map = {
            'A': 'Infectious/Parasitic', 'B': 'Infectious/Parasitic',
            'C': 'Neoplasms', 'D': 'Blood/Immune disorders',
            'E': 'Endocrine/Metabolic', 'F': 'Mental disorders',
            'G': 'Nervous system', 'H': 'Eye/Ear disorders',
            'I': 'Circulatory system', 'J': 'Respiratory system',
            'K': 'Digestive system', 'L': 'Skin disorders',
            'M': 'Musculoskeletal', 'N': 'Genitourinary',
            'O': 'Pregnancy/Childbirth', 'P': 'Perinatal conditions',
            'Q': 'Congenital malformations', 'R': 'Symptoms/Ill-defined',
            'S': 'Injury/Poisoning', 'T': 'Injury/Poisoning',
            'V': 'External causes', 'W': 'External causes',
            'X': 'External causes', 'Y': 'External causes',
        }
        chapter_counts = {}
        for code in icd_codes:
            if len(code) > 0:
                ch = icd_chapter_map.get(code[0], 'Other')
                chapter_counts[ch] = chapter_counts.get(ch, 0) + 1
        # Sort by count descending
        dashboard['icd10_causes'] = dict(sorted(chapter_counts.items(), key=lambda x: -x[1]))

    # ── 8. Demographics ─────────────────────────────────────────
    print("Computing demographics...")
    dashboard['education'] = label_counts(iq['Q108A'], EDUCATION_LABELS)
    dashboard['religion'] = label_counts(iq['Q122'], RELIGION_LABELS)
    dashboard['ethnicity'] = label_counts(iq['Q123'], ETHNICITY_LABELS)
    dashboard['residence_type'] = label_counts(iq['QTYPE'], TYPE_LABELS)

    # Age distribution of women
    ages = iq['Q106'].dropna()
    ages = ages[(ages >= 10) & (ages < 98)]
    age_groups = {'15-19': 0, '20-24': 0, '25-29': 0, '30-34': 0,
                  '35-39': 0, '40-44': 0, '45-49': 0}
    for a in ages:
        if 15 <= a <= 19: age_groups['15-19'] += 1
        elif 20 <= a <= 24: age_groups['20-24'] += 1
        elif 25 <= a <= 29: age_groups['25-29'] += 1
        elif 30 <= a <= 34: age_groups['30-34'] += 1
        elif 35 <= a <= 39: age_groups['35-39'] += 1
        elif 40 <= a <= 44: age_groups['40-44'] += 1
        elif 45 <= a <= 49: age_groups['45-49'] += 1
    dashboard['women_age_distribution'] = age_groups

    # Wealth index
    dashboard['wealth_index'] = label_counts(hh['QHWLTHI'], WEALTH_LABELS)

    # ── 9. Pregnancy outcomes by region ─────────────────────────
    print("Computing pregnancy outcomes by region...")
    preg_by_region = {}
    for reg_val, reg_name in REGION_LABELS.items():
        mask = bq['QREGION'] == reg_val
        preg_by_region[reg_name] = label_counts(bq.loc[mask, 'PREGOUT'], PREGOUT_LABELS)
    dashboard['pregnancy_outcomes_by_region'] = preg_by_region

    # ── 10. Postnatal care ──────────────────────────────────────
    print("Computing postnatal care...")
    pnc_mother = safe_count(bq['Q435'], 1.0)
    pnc_mother_total = int(bq['Q435'].isin([1.0, 2.0]).sum())
    pnc_child = safe_count(bq['Q438B'], 1.0)
    pnc_child_total = int(bq['Q438B'].isin([1.0, 2.0]).sum())
    dashboard['postnatal_care'] = {
        'mother_check_pct': safe_pct(pnc_mother, pnc_mother_total),
        'child_check_pct': safe_pct(pnc_child, pnc_child_total),
        'mother_checked': pnc_mother,
        'child_checked': pnc_child,
    }

    # ── 11. Delivery complications ──────────────────────────────
    print("Computing delivery complications...")
    comp_yes = safe_count(bq['Q431C'], 1.0)
    comp_total = int(bq['Q431C'].isin([1.0, 2.0]).sum())
    dashboard['delivery_complications'] = {
        'experienced': comp_yes,
        'total_asked': comp_total,
        'rate': safe_pct(comp_yes, comp_total)
    }

    # ── 12. Health-seeking for complications ────────────────────
    # Of those with complications, who sought care
    comp_mask = bq['Q431C'] == 1.0
    sought_care = safe_count(bq.loc[comp_mask, 'Q431E'], 1.0)
    not_sought = safe_count(bq.loc[comp_mask, 'Q431E'], 2.0)
    dashboard['complication_care_seeking'] = {
        'sought_care': sought_care,
        'did_not_seek': not_sought,
        'pct_sought': safe_pct(sought_care, sought_care + not_sought)
    }

    # ── 13. Tetanus & malaria prevention ────────────────────────
    print("Computing preventive care...")
    tet_yes = safe_count(bq['Q414'], 1.0)
    tet_total = int(bq['Q414'].isin([1.0, 2.0]).sum())
    iron_yes = safe_count(bq['Q420'], 1.0)
    iron_total = int(bq['Q420'].isin([1.0, 2.0]).sum())
    malaria_yes = safe_count(bq['Q423'], 1.0)
    malaria_total = int(bq['Q423'].isin([1.0, 2.0]).sum())
    dashboard['preventive_care'] = {
        'Tetanus injection': safe_pct(tet_yes, tet_total),
        'Iron tablets': safe_pct(iron_yes, iron_total),
        'Malaria prophylaxis (SP/Fansidar)': safe_pct(malaria_yes, malaria_total),
    }

    # ── 14. Skilled birth attendance by region ──────────────────
    print("Computing skilled attendance by region...")
    sba_by_region = {}
    for reg_val, reg_name in REGION_LABELS.items():
        mask = bq['QREGION'] == reg_val
        skilled = int(bq.loc[mask, 'Q429'].isin(['A', 'B', 'C']).sum())
        total = int(bq.loc[mask, 'Q429'].notna().sum())
        sba_by_region[reg_name] = safe_pct(skilled, total)
    dashboard['skilled_attendance_by_region'] = sba_by_region

    # ── 15. Year of death distribution (VA) ─────────────────────
    death_years = va['Q102Y'].dropna()
    death_years = death_years[(death_years >= 2000) & (death_years <= 2020)]
    year_counts = {}
    for y in sorted(death_years.unique()):
        year_counts[str(int(y))] = int((death_years == y).sum())
    dashboard['deaths_by_year'] = year_counts

    # ── 16. Pregnancy outcomes by urban/rural ───────────────────
    preg_by_type = {}
    for type_val, type_name in TYPE_LABELS.items():
        mask = bq['QTYPE'] == type_val
        preg_by_type[type_name] = label_counts(bq.loc[mask, 'PREGOUT'], PREGOUT_LABELS)
    dashboard['pregnancy_outcomes_by_residence'] = preg_by_type

    # ── 17. Facility delivery by region ─────────────────────────
    facility_by_region = {}
    for reg_val, reg_name in REGION_LABELS.items():
        mask = bq['QREGION'] == reg_val
        facility = int(bq.loc[mask, 'Q430'].isin(facility_codes).sum())
        home = int(bq.loc[mask, 'Q430'].isin(home_codes).sum())
        total = facility + home
        facility_by_region[reg_name] = safe_pct(facility, total)
    dashboard['facility_delivery_by_region'] = facility_by_region

    # ── 18. Birth weight ────────────────────────────────────────
    weights = bq['Q428N'].dropna()
    weights = weights[(weights > 0) & (weights < 10)]  # reasonable range in kg
    weight_cats = {'Very low (<1.5 kg)': 0, 'Low (1.5-2.5 kg)': 0,
                   'Normal (2.5-4.0 kg)': 0, 'High (>4.0 kg)': 0}
    for w in weights:
        if w < 1.5: weight_cats['Very low (<1.5 kg)'] += 1
        elif w < 2.5: weight_cats['Low (1.5-2.5 kg)'] += 1
        elif w <= 4.0: weight_cats['Normal (2.5-4.0 kg)'] += 1
        else: weight_cats['High (>4.0 kg)'] += 1
    dashboard['birth_weight'] = weight_cats

    # ── 19. Child size at birth ─────────────────────────────────
    size_labels = {1.0: 'Very large', 2.0: 'Larger than average', 3.0: 'Average',
                   4.0: 'Smaller than average', 5.0: 'Very small'}
    dashboard['child_size_at_birth'] = label_counts(bq['Q426B'], size_labels)

    # ── 20. Contraceptive use ───────────────────────────────────
    contra_using = safe_count(iq['Q303'], 1.0)
    contra_total = int(iq['Q303'].isin([1.0, 2.0]).sum())
    dashboard['contraceptive_use'] = {
        'currently_using': contra_using,
        'not_using': contra_total - contra_using,
        'prevalence_pct': safe_pct(contra_using, contra_total)
    }

    # Save to JSON
    print("Saving dashboard data...")
    with open('data/dashboard_data.json', 'w') as f:
        json.dump(dashboard, f, indent=2)

    print(f"Done! Saved to data/dashboard_data.json")
    print(f"Total data keys: {len(dashboard)}")

if __name__ == '__main__':
    extract_all()
