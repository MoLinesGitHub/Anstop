# 💰 Estrategia de Monetización - Anstop

## Resumen Ejecutivo

Este documento describe las estrategias implementadas para hacer la app Anstop rentable de forma rápida y eficiente en el mercado de aplicaciones.

## Modelo de Negocio: Freemium con Suscripciones

### Precios Actuales
- **Premium Mensual**: €9.99/mes
- **Premium Anual**: €59.99/año (ahorro del 50%)
- **Prueba Gratuita**: 7 días para ambos planes

### Proyección de Ingresos
- Meta inicial: 2,500 - 5,000 €/mes
- Meta escalable: 80,000 €/mes
- Tasa de conversión objetivo: 3-7%

---

## Estrategias Implementadas

### 1. 🎁 Oferta de Prueba Gratuita (7 días)

**Ubicación**: PaywallView.swift, Configuration.storekit

**Beneficios**:
- Reduce fricción de conversión
- Permite al usuario experimentar el valor completo
- Aumenta confianza en la compra

**Implementación**:
- Configurado en StoreKit con `introductoryOffer`
- CTA prominente "Comenzar 7 días GRATIS"
- Mensaje claro de "Cancela cuando quieras"

### 2. 📊 Social Proof y Testimonios

**Ubicación**: PaywallView.swift (TestimonialsCarousel)

**Elementos**:
- Carrusel de testimonios con valoración de 5 estrellas
- Estadísticas impactantes:
  - "93% reducen ansiedad"
  - "4.9★ valoración"
  - "+50,000 usuarios"

**Impacto esperado**: +15-25% en tasa de conversión

### 3. ⏰ Urgencia y Escasez

**Ubicación**: PaywallView.swift

**Elementos implementados**:
- Badge "OFERTA DE BIENVENIDA"
- Countdown timer de 15 minutos
- Mensaje "Oferta termina en: XX:XX"

**Impacto esperado**: +10-20% en conversiones inmediatas

### 4. 🎯 Soft Paywall en Onboarding

**Ubicación**: OnboardingView.swift (SoftPaywallStep)

**Estrategia**:
- Mostrar valor premium al final del onboarding
- Beneficios claros con checkmarks verdes
- Opción de continuar gratis sin fricción
- CTA "Comenzar prueba gratuita"

**Impacto esperado**: 2-5% de nuevos usuarios convierten inmediatamente

### 5. 🔔 Triggers Estratégicos de Paywall

**Ubicaciones**:

a) **PanicFlowView.swift** - Después de completar ejercicio:
   - Momento de alto engagement
   - Usuario ha experimentado valor
   - Sugerencia contextual de Premium

b) **HomeView.swift** - Banner Premium:
   - Siempre visible para usuarios gratuitos
   - CTA directo a paywall

c) **SettingsView.swift** - Sección de Suscripción:
   - Acceso fácil para usuarios que buscan upgrade

### 6. 🏷️ Etiquetas PRO en Funciones

**Ubicación**: HomeView.swift (QuickAccessButton)

**Funciones marcadas**:
- Audio calmante - PRO
- Asistente IA - PRO
- Programa de 30 días - PRO

**Objetivo**: Crear FOMO y mostrar valor bloqueado

---

## Métricas Clave (KPIs)

### Conversión
- Trial to Paid: Meta 40%+
- Free to Trial: Meta 5-10%
- Overall Free to Paid: Meta 3-7%

### Retención
- Día 1: Meta >50%
- Día 7: Meta >30%
- Día 30: Meta >15%

### Adquisición
- CAC (Costo de Adquisición): Meta <€2
- LTV (Lifetime Value): Meta >€30

---

## Próximos Pasos para Aumentar Ingresos

### Corto Plazo (1-2 semanas)
1. [ ] A/B testing de variantes de paywall
2. [ ] Implementar deep links para campañas
3. [ ] Optimizar textos de conversión

### Medio Plazo (1-2 meses)
1. [ ] Push notifications de re-engagement
2. [ ] Ofertas especiales por temporada
3. [ ] Programa de referidos

### Largo Plazo (3-6 meses)
1. [ ] Tier Enterprise/B2B para empresas
2. [ ] Localización a más idiomas
3. [ ] Expansión a watchOS/iPadOS

---

## Optimización de App Store (ASO)

### Keywords Objetivo
- "ansiedad app"
- "ataques de pánico ayuda"
- "respiración relajación"
- "meditación ansiedad"
- "calmar ansiedad"

### Screenshots Sugeridos
1. Botón de pánico con mensaje empático
2. Ejercicio de respiración en acción
3. Programa de 30 días con progreso
4. Testimonios y valoraciones
5. Comparación Free vs Premium

---

## Marketing de Bajo Costo

### Orgánico
- TikTok: Videos de respiración y tips
- Instagram Reels: Testimonios y ejercicios
- SEO: Blog de ansiedad en landing page

### Paid (cuando escale)
- Apple Search Ads
- Facebook/Instagram Ads con lookalike audiences
- Influencer partnerships en salud mental

---

## Cumplimiento Legal

✅ **Implementado**:
- Disclaimer "No sustituye ayuda profesional"
- Política de privacidad accesible
- Términos de uso claros
- Mensaje de renovación automática

---

## Contacto y Soporte

Para consultas sobre monetización o partnership:
- Email: admin@molinesdesigns.com
- Web: molinesdesigns.com/anstop

---

*Documento actualizado: Diciembre 2025*
