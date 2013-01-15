%(C) Inne Lemstra 13-12-12%

function [bron,invoer] = test_omgeving(n,bronnen)
    
    bron = randi([0,30], bronnen,2)   %positie van de bronnen random initieren%
    
    
    geluids_snelheid = 343.20     %in meter per seconde%
    x = 0:(1/44100):1;            %het aantal frames (per seconde) voor het meten van de microfoons%
    
    for i = 1:bronnen             %handmatoge invoer van de frequenties vd bronnen%
        sprintf('voer frequentie van bron %d in', i)
        hz = input(':');
        bron(i,3) = hz;
        hold on;
        
    end
    
    for i=1:n                     %eerste loop, het aantal microfoons, bepaald het waargenomen geluid per microfoon
        count = i
        golfen = zeros(1,44101); %een vector van nullen voor het waargenomen geluid, dit is voor de eerste keer optellen vd golven%
        
        mics(i,:) = [(30/n)*i,0]       %posities van de microfoons in een vector, evenredig verdeelt over de x-as%
        
        for j = 1:bronnen           %tweede loop gaat alle bronnen af en telt de (geluids)golven bij die van de eerder waargenomen golven op%
            counter = j
            afstand = [sqrt(sum((mics(i,1:2)-bron(j,1:2)).^2))] %afstand tussen microfoons en bronnen, hier zit een wortel in. dat is erg intensief kan wellicht een oplossing voor gevonden worden.%
            
            vertraging = afstand/geluids_snelheid               %in seconden %
            vertraging = vertraging*44100                       %in aantal gemiste metingen%
            corrected_x = [(x(1:vertraging) - x(1:vertraging)),x(vertraging:end)];    %maakt het eerste gemiste gedeelte van de golf 0%
            golfen = sin(2*pi*(corrected_x*bron(i,3))) + golfen;  %Berekent de golf van de huidige bron dmv sin(2pi*(x*hz)), en telt deze op bij de som van de eerdere golven%
            
            bron(j,i+3) = vertraging
        end

        
    invoer(i,:) = golfen(:);                                  
      
    end
    
    %%%%tekening vd opstelling%%%%
    
    if n > bronnen
    punten = n
    else
    punten = bronnen
    end
    
    hold off;
    
    for t=1:punten
        if t <=bronnen
        plot(bron(t,1),bron(t,2),'b*');
        hold on;
        end
        
        if t <= n
        plot(mics(t,1),mics(t,2),'r^');
        hold on;
        end
    end
    hold off;
end